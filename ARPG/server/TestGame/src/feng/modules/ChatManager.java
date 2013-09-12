package feng.modules;

import feng.AllReference;
import feng.data.PlayerData;
import feng.sql.model.Player;

/**
 * 
 * @author 风之守望者 2013-9-12
 */
public class ChatManager
{

	public void speak(int clientId, String msg)
	{
		BroadcastManager broadcastManager = AllReference.getBroadcastManager();
		PlayerData playerData = AllReference.getPlayerDataManager().getPlayerData(clientId);
		Player player = playerData.player;
		
		// 广播玩家释放技能
		broadcastManager.speak(player.getId(),player.getUsername(),msg);
	}
	
}
