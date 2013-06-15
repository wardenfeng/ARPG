package feng.modules;

import feng.AllReference;
import feng.CommonData;
import feng.client.Client;
import feng.data.PlayerData;
import feng.data.PlayerDataManager;
import feng.sql.SQLManager;
import feng.sql.dao.PlayerDao;

/**
 * 掉线处理
 * 
 * @author 风之守望者 2013-6-3
 */
public class LogoutManager
{
	public void disconnect(int clientId)
	{
		// 登出
		if (CommonData.loginedClientMap.containsKey(clientId))
		{
			Client client = AllReference.getClient(clientId);
			SQLManager sqlManager = client.getSqlManager();
			PlayerDataManager playerDataManager = AllReference.getPlayerDataManager();

			PlayerData playerData = playerDataManager.getPlayerData(clientId);

			// 保存玩家数据
			saveData(sqlManager, playerData);

			// 删除玩家数据
			playerDataManager.removePlayerData(clientId);

			CommonData.loginedClientMap.remove(clientId);

			// 广播删除玩家
			BroadcastManager broadcastManager = AllReference.getBroadcastManager();
			broadcastManager.removePlayer(clientId, playerData.player.getId());
		}
	}

	/**
	 * 保存数据
	 */
	private void saveData(SQLManager sqlManager, PlayerData playerDataCenter)
	{
		if (sqlManager != null)
		{
			PlayerDao playerDao = sqlManager.getPlayerDao();
			playerDao.update(playerDataCenter.player);
		}
	}
}
