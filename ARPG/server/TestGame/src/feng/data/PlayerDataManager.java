package feng.data;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

/**
 * 玩家数据管理
 * 
 * @author 风之守望者 2013-6-3
 */
public class PlayerDataManager
{
	private Map<Integer, PlayerData> playerDataMap;

	public PlayerDataManager()
	{
		playerDataMap = new HashMap<Integer, PlayerData>();
	}

	public PlayerData createPlayerData(int clientId)
	{
		PlayerData playerData = new PlayerData(clientId);
		playerDataMap.put(clientId, playerData);
		return playerData;
	}

	public PlayerData getPlayerData(int clientId)
	{
		return playerDataMap.get(clientId);
	}

	public void removePlayerData(int clientId)
	{
		playerDataMap.remove(clientId);
	}

	public ArrayList<PlayerData> getNearPlayers(int srcId)
	{
		ArrayList<PlayerData> arrayList = new ArrayList<PlayerData>();

		Iterator<Entry<Integer, PlayerData>> iter = playerDataMap.entrySet().iterator();
		while (iter.hasNext())
		{
			Entry<Integer, PlayerData> entry = (Entry<Integer, PlayerData>) iter.next();
			arrayList.add(entry.getValue());
		}
		return arrayList;
	}
}