package feng.modules;

import protobuf.ARPGProto.ASPKG_MOVE_ACK.E_MOVE_RESULT;
import feng.AllReference;
import feng.MsgSender;
import feng.data.PlayerData;

/**
 * 
 * @author warden_feng 2013-6-2
 */
public class MoveManager
{
	private int clientId;

	public MoveManager(int clientId)
	{
		this.clientId = clientId;
	}

	public void walk(int mapX, int mapY)
	{
		PlayerData playerData = AllReference.getPlayerDataManager().getPlayerData(clientId);
		playerData.player.setMapX(mapX);
		playerData.player.setMapY(mapY);

		//响应客户端结果
		MsgSender msgSender = AllReference.getMsgSender(clientId);
		msgSender.OnRecvWalkAck(E_MOVE_RESULT.SUCCEED);
		
		//广播玩家行走
		BroadcastManager broadcastManager = AllReference.getBroadcastManager();
		broadcastManager.move(clientId,playerData.player.getId(),playerData.player.getUsername(),mapX,mapY);
	}
}
