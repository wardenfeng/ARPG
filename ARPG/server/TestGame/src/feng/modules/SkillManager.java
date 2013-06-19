package feng.modules;

import java.util.ArrayList;

import protobuf.ARPGProto.ASPKG_CAST_SKILL_ACK.E_CAST_SKILL_RESULT;
import protobuf.ARPGProto.E_ATTACK_TYPE;
import protobuf.ARPGProto.E_OBJECT_TYPE;
import protobuf.ARPGProto.SKILL_HARM;
import feng.AllReference;
import feng.CommonData;
import feng.MsgSender;
import feng.data.PlayerData;
import feng.sql.model.Player;

/**
 * 
 * @author 风之守望者 2013-6-6
 */
public class SkillManager
{
	public void castSkill(int clientId, int skillId, int targetId, int mapX, int mapY, E_ATTACK_TYPE type)
	{
		BroadcastManager broadcastManager = AllReference.getBroadcastManager();

		PlayerData playerData = AllReference.getPlayerDataManager().getPlayerData(clientId);
		Player attacker = playerData.player;

		E_CAST_SKILL_RESULT result = E_CAST_SKILL_RESULT.SUCCEED;
		// 判断玩家魔法值
//		if (attacker.getMp() < 5)
//		{
//			result = E_CAST_SKILL_RESULT.FAIL;
//		}

		// 响应客户端结果
		MsgSender msgSender = AllReference.getMsgSender(clientId);
		msgSender.OnRecvCastSkillAck(result);

		if (result == E_CAST_SKILL_RESULT.SUCCEED)
		{
			// 处理是否技能
			attacker.setMp(attacker.getMp() - 5);
			broadcastManager.MpUpdate(attacker.getId(), attacker.getMp());

			ArrayList<SKILL_HARM> skillHarmList = new ArrayList<SKILL_HARM>();

			if (type == E_ATTACK_TYPE.PLALER)
			{
				int targetClinetId = CommonData.playerClientMap.get(targetId);
				Player target = AllReference.getPlayerDataManager().getPlayerData(targetClinetId).player;
				int harmValue = Math.max(-10, -target.getHp());
				target.setHp(target.getHp() + harmValue);
				// broadcastManager.HpUpdate(target.getId(), target.getHp());
				SKILL_HARM skillHarm = SKILL_HARM.newBuilder().setType(E_OBJECT_TYPE.PLAYER).setTargetId(targetId)
						.setHarmValue(harmValue).build();
				skillHarmList.add(skillHarm);
			}

			// 广播玩家释放技能
			broadcastManager.castSkill(clientId, attacker.getId(), skillId, targetId, mapX, mapY, type,skillHarmList);
		}
	}
}
