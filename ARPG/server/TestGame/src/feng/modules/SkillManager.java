package feng.modules;

import protobuf.ARPGProto.ASPKG_CAST_SKILL_ACK.E_CAST_SKILL_RESULT;
import feng.AllReference;
import feng.MsgSender;
import feng.data.PlayerData;

/**
 * 
 * @author 风之守望者 2013-6-6
 */
public class SkillManager
{
	public void castSkill(int clientId, int skillId, int mapX, int mapY)
	{
		PlayerData playerData = AllReference.getPlayerDataManager().getPlayerData(clientId);

		// 响应客户端结果
		MsgSender msgSender = AllReference.getMsgSender(clientId);
		msgSender.OnRecvCastSkillAck(E_CAST_SKILL_RESULT.SUCCEED);

		// 广播玩家释放技能
		BroadcastManager broadcastManager = AllReference.getBroadcastManager();
		broadcastManager.castSkill(clientId, playerData.player.getId(), skillId, mapX, mapY);
	}

	public void castSkill(int clientId, int skillId, int targetId)
	{
		PlayerData playerData = AllReference.getPlayerDataManager().getPlayerData(clientId);

		// 响应客户端结果
		MsgSender msgSender = AllReference.getMsgSender(clientId);
		msgSender.OnRecvCastSkillAck(E_CAST_SKILL_RESULT.SUCCEED);

		// 广播玩家释放技能
		BroadcastManager broadcastManager = AllReference.getBroadcastManager();
		broadcastManager.castSkill(clientId, playerData.player.getId(), skillId, targetId);

	}
}
