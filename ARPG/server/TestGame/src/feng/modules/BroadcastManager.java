package feng.modules;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map.Entry;

import protobuf.ARPGProto.E_ATTACK_TYPE;
import protobuf.ARPGProto.SKILL_HARM;

import feng.AllReference;
import feng.CommonData;
import feng.MsgSender;
import feng.client.Client;
import feng.sql.model.Player;

/**
 * 
 * @author warden_feng 2013-6-2
 */
public class BroadcastManager
{
	/**
	 * 广播行走
	 * 
	 * @param clientId
	 * @param id
	 * @param username
	 * @param mapX
	 * @param mapY
	 */
	public void move(int srcId, int playerId, String username, int mapX, int mapY)
	{
		Iterator<Entry<Integer, Client>> iter = CommonData.loginedClientMap.entrySet().iterator();
		while (iter.hasNext())
		{
			Entry<Integer, Client> entry = (Entry<Integer, Client>) iter.next();
			int clientId = (int) entry.getKey();

			MsgSender msgSender = AllReference.getMsgSender(clientId);
			msgSender.OnRecvWalkNtf(playerId, mapX, mapY);
		}
	}

	public void addPlayer(int srcId, Player player)
	{
		Iterator<Entry<Integer, Client>> iter = CommonData.loginedClientMap.entrySet().iterator();
		while (iter.hasNext())
		{
			Entry<Integer, Client> entry = (Entry<Integer, Client>) iter.next();
			int clientId = (int) entry.getKey();

			MsgSender msgSender = AllReference.getMsgSender(clientId);
			msgSender.OnRecvAddPlayerNtf(player);
		}
	}

	public void removePlayer(int srcId, int playerId)
	{
		Iterator<Entry<Integer, Client>> iter = CommonData.loginedClientMap.entrySet().iterator();
		while (iter.hasNext())
		{
			Entry<Integer, Client> entry = (Entry<Integer, Client>) iter.next();
			int clientId = (int) entry.getKey();

			MsgSender msgSender = AllReference.getMsgSender(clientId);
			msgSender.OnRecvRemovePlayerNtf(playerId);
		}
	}

	public void castSkill(int srcId, int playerId, int skillId, int targetId, int mapX, int mapY, E_ATTACK_TYPE type,
			ArrayList<SKILL_HARM> skillHarmList)
	{
		Iterator<Entry<Integer, Client>> iter = CommonData.loginedClientMap.entrySet().iterator();
		while (iter.hasNext())
		{
			Entry<Integer, Client> entry = (Entry<Integer, Client>) iter.next();
			int clientId = (int) entry.getKey();

			MsgSender msgSender = AllReference.getMsgSender(clientId);
			msgSender.OnRecvCastSkillNtf(playerId, skillId, targetId, mapX, mapY, type,skillHarmList);
		}
	}

	public void HpUpdate(int playerId, int hp)
	{
		Iterator<Entry<Integer, Client>> iter = CommonData.loginedClientMap.entrySet().iterator();
		while (iter.hasNext())
		{
			Entry<Integer, Client> entry = (Entry<Integer, Client>) iter.next();
			int clientId = (int) entry.getKey();

			MsgSender msgSender = AllReference.getMsgSender(clientId);
			msgSender.OnRecvHPUpdateNtf(playerId, hp);
		}
	}

	public void MpUpdate(int playerId, int mp)
	{
		Iterator<Entry<Integer, Client>> iter = CommonData.loginedClientMap.entrySet().iterator();
		while (iter.hasNext())
		{
			Entry<Integer, Client> entry = (Entry<Integer, Client>) iter.next();
			int clientId = (int) entry.getKey();

			MsgSender msgSender = AllReference.getMsgSender(clientId);
			msgSender.OnRecvMPUpdateNtf(playerId, mp);
		}
	}

}