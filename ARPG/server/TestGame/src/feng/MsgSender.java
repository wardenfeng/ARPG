package feng;

import java.io.DataOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import protobuf.ARPGProto;
import protobuf.ARPGProto.ADD_MONSTER;
import protobuf.ARPGProto.ADD_PLAYER;
import protobuf.ARPGProto.ASPKG_ADD_MONSTER_NTF;
import protobuf.ARPGProto.ASPKG_ADD_PLAYER_NTF;
import protobuf.ARPGProto.ASPKG_CAST_SKILL_ACK;
import protobuf.ARPGProto.ASPKG_CAST_SKILL_ACK.E_CAST_SKILL_RESULT;
import protobuf.ARPGProto.ASPKG_CAST_SKILL_NTF;
import protobuf.ARPGProto.ASPKG_HP_UPDATE_NTF;
import protobuf.ARPGProto.ASPKG_LOGIN_ACK;
import protobuf.ARPGProto.ASPKG_MP_UPDATE_NTF;
import protobuf.ARPGProto.ASPKG_REMOVE_PLAYER_NTF;
import protobuf.ARPGProto.SKILL_HARM;
import protobuf.ARPGProto.ASPKG_LOGIN_ACK.E_LOGIN_RESULT;
import protobuf.ARPGProto.ASPKG_MOVE_ACK;
import protobuf.ARPGProto.ASPKG_MOVE_ACK.E_MOVE_RESULT;
import protobuf.ARPGProto.ASPKG_MOVE_NTF;
import protobuf.ARPGProto.E_ATTACK_TYPE;

import com.google.protobuf.Message;

import feng.data.PlayerData;
import feng.network.Protocol;
import feng.network.SocketManager;
import feng.sql.model.Monster;
import feng.sql.model.Player;

/**
 * 
 * @author 风之守望者 2013-2-24
 */
public class MsgSender
{
	private int clientId;

	public MsgSender(int clientId)
	{
		// TODO Auto-generated constructor stub
		this.clientId = clientId;
	}

	public void send(int msgId, Message message)
	{
		byte[] data = message.toByteArray();

		ByteBuffer byteBuffer = ByteBuffer.allocate(1024);
		byteBuffer.putInt(data.length + SocketManager.DESCRIPTION_LENGTH);
		// MAGIC_NUMBER
		byteBuffer.putInt(502);
		byteBuffer.putInt(msgId);
		byteBuffer.put(data);

		DataOutputStream writer = AllReference.getWriter(clientId);

		try
		{
			writer.write(byteBuffer.array(), 0, byteBuffer.position());
		}
		catch (IOException e)
		{
			System.out.println("发送协议失败，msgId:" + msgId + "，clientId:" + clientId);
			e.printStackTrace();
		}
	}

	public void OnRecvLoginAck(E_LOGIN_RESULT result, Player player)
	{
		protobuf.ARPGProto.ASPKG_LOGIN_ACK.Builder builder = ASPKG_LOGIN_ACK.newBuilder();
		builder.setResult(E_LOGIN_RESULT.SUCCEED);
		if (player != null)
		{
			builder.setUsername(player.getUsername());
			builder.setMapX(player.getMapX());
			builder.setMapY(player.getMapY());
			builder.setPlayerId(player.getId());
			builder.setClothing(player.getClothing());
			builder.setMapId(player.getMapId());
			builder.setHP(player.getHp());
			builder.setMP(player.getMp());
		}
		ASPKG_LOGIN_ACK login_ack = builder.build();
		send(Protocol.ASID_LOGIN_ACK, login_ack);
	}

	public void OnRecvWalkAck(E_MOVE_RESULT succeed)
	{
		ASPKG_MOVE_ACK walkAck = ASPKG_MOVE_ACK.newBuilder().setResult(succeed).build();
		send(Protocol.ASID_MOVE_ACK, walkAck);
	}

	public void OnRecvWalkNtf(int playerId, int mapX, int mapY)
	{
		ASPKG_MOVE_NTF walkNtf = ASPKG_MOVE_NTF.newBuilder().setPlayerId(playerId).setMapX(mapX).setMapY(mapY).build();
		send(Protocol.ASID_MOVE_NTF, walkNtf);
	}

	public void OnRecvAddPlayerNtf(Player player)
	{
		ADD_PLAYER addplayer = ADD_PLAYER.newBuilder().setPlayerId(player.getId()).setUsername(player.getUsername())
				.setMapX(player.getMapX()).setMapY(player.getMapY()).setHP(player.getHp()).setMP(player.getMp())
				.setClothing(player.getClothing()).build();
		ASPKG_ADD_PLAYER_NTF addPlayerNtf = ASPKG_ADD_PLAYER_NTF.newBuilder().addAddPlayer(addplayer).build();
		send(Protocol.ASID_ADD_PLAYER_NTF, addPlayerNtf);
	}

	public void OnRecvAddPlayerNtf(ArrayList<PlayerData> arrayList)
	{
		ARPGProto.ASPKG_ADD_PLAYER_NTF.Builder builder = ASPKG_ADD_PLAYER_NTF.newBuilder();
		for (Iterator<PlayerData> i = arrayList.iterator(); i.hasNext();)
		{
			PlayerData playerData = i.next();
			Player player = playerData.player;
			ADD_PLAYER addplayer = ADD_PLAYER.newBuilder().setPlayerId(player.getId())
					.setUsername(player.getUsername()).setMapX(player.getMapX()).setMapY(player.getMapY())
					.setHP(player.getHp()).setMP(player.getMp()).setClothing(player.getClothing()).build();
			builder.addAddPlayer(addplayer);
		}
		send(Protocol.ASID_ADD_PLAYER_NTF, builder.build());
	}

	public void OnRecvRemovePlayerNtf(int playerId)
	{
		ASPKG_REMOVE_PLAYER_NTF removePlayerNtf = ASPKG_REMOVE_PLAYER_NTF.newBuilder().setPlayerId(playerId).build();
		send(Protocol.ASID_REMOVE_PLAYER_NTF, removePlayerNtf);
	}

	public void OnRecvCastSkillAck(E_CAST_SKILL_RESULT succeed)
	{
		ASPKG_CAST_SKILL_ACK castSkillAck = ASPKG_CAST_SKILL_ACK.newBuilder().setResult(succeed).build();
		send(Protocol.ASID_CAST_SKILL_ACK, castSkillAck);
	}

	public void OnRecvCastSkillNtf(int playerId, int skillId, int targetId, int mapX, int mapY, E_ATTACK_TYPE type,
			ArrayList<SKILL_HARM> skillHarmList)
	{
		ASPKG_CAST_SKILL_NTF castSkillNtf = ASPKG_CAST_SKILL_NTF.newBuilder().setPlayerId(playerId)
				.setSkillId(skillId).setType(type).setTargetId(targetId).setMapX(mapX).setMapY(mapY)
				.addAllSkillHarms(skillHarmList).build();
		send(Protocol.ASID_CAST_SKILL_NTF, castSkillNtf);
	}

	public void OnRecvHPUpdateNtf(int playerId, int hp)
	{
		ASPKG_HP_UPDATE_NTF hpUpdateNf = ASPKG_HP_UPDATE_NTF.newBuilder().setPlayerId(playerId).setHP(hp).build();
		send(Protocol.ASID_HP_UPDATE_NTF, hpUpdateNf);
	}

	public void OnRecvMPUpdateNtf(int playerId, int mp)
	{
		ASPKG_MP_UPDATE_NTF mpUpdateNf = ASPKG_MP_UPDATE_NTF.newBuilder().setPlayerId(playerId).setMP(mp).build();
		send(Protocol.ASID_MP_UPDATE_NTF, mpUpdateNf);
	}

	public void OnRecvAddMonsterNtf(List<Monster> monsterList)
	{
		ASPKG_ADD_MONSTER_NTF.Builder builder = ASPKG_ADD_MONSTER_NTF.newBuilder();
				
		for (Iterator<Monster> i = monsterList.iterator(); i.hasNext();)
		{
			Monster monster = i.next();
			ADD_MONSTER addMonster = ADD_MONSTER.newBuilder().setMonsterId(monster.getId()).setTypeId(monster.getTypeId()).setMapX(monster.getMapX()).setMapY(monster.getMapY()).setHP(monster.getHp()).build();
			builder.addAddMonster(addMonster);
		}
		send(Protocol.ASID_ADD_MONSTER_NTF,builder.build());
	}
}
