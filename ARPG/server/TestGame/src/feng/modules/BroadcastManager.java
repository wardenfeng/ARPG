package feng.modules;

import java.util.Iterator;
import java.util.Map.Entry;

import feng.AllReference;
import feng.CommonData;
import feng.MsgSender;
import feng.client.Client;
import feng.sql.model.Player;

/**
 * 
 * @author 风之守望者 2013-6-2
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

	public void castSkill(int srcId, int playerId, int skillId, int mapX, int mapY)
	{
		Iterator<Entry<Integer, Client>> iter = CommonData.loginedClientMap.entrySet().iterator();
		while (iter.hasNext())
		{
			Entry<Integer, Client> entry = (Entry<Integer, Client>) iter.next();
			int clientId = (int) entry.getKey();

			MsgSender msgSender = AllReference.getMsgSender(clientId);
			msgSender.OnRecvCastSkillNtf(playerId, skillId, mapX, mapY);
		}
	}

	public void castSkill(int srcId, int playerId, int skillId, int targetId)
	{
		Iterator<Entry<Integer, Client>> iter = CommonData.loginedClientMap.entrySet().iterator();
		while (iter.hasNext())
		{
			Entry<Integer, Client> entry = (Entry<Integer, Client>) iter.next();
			int clientId = (int) entry.getKey();

			MsgSender msgSender = AllReference.getMsgSender(clientId);
			msgSender.OnRecvCastSkillNtf(playerId, skillId, targetId);
		}
	}
}