package feng;

import java.io.DataOutputStream;

import feng.client.Client;
import feng.data.PlayerDataManager;
import feng.modules.BroadcastManager;
import feng.modules.ChatManager;
import feng.modules.LoginManager;
import feng.modules.LogoutManager;
import feng.modules.ModulesManager;
import feng.modules.SkillManager;
import feng.network.SocketManager;

/**
 * 
 * @author warden_feng 2012-1-4
 */
public class AllReference
{
	/**
	 * 根据客户编号返回客户实例
	 * 
	 * @param clientId
	 *            客户编号
	 * @return 客户实例
	 */
	public static Client getClient(int clientId)
	{
		return CommonData.connectedClientMap.get(clientId);
	}

	private static BroadcastManager broadcastManager;

	public static BroadcastManager getBroadcastManager()
	{
		if (broadcastManager == null)
		{
			broadcastManager = new BroadcastManager();
		}
		return broadcastManager;
	}

	private static LogoutManager logoutManager;

	public static LogoutManager getLogoutManager()
	{
		if (logoutManager == null)
		{
			logoutManager = new LogoutManager();
		}
		return logoutManager;
	}

	private static PlayerDataManager playerDataManager;

	public static PlayerDataManager getPlayerDataManager()
	{
		if (playerDataManager == null)
		{
			playerDataManager = new PlayerDataManager();
		}
		return playerDataManager;
	}

	private static SkillManager skillManager;

	public static SkillManager getSkillManager()
	{
		if (skillManager == null)
		{
			skillManager = new SkillManager();
		}
		return skillManager;
	}
	
	private static ChatManager chatManager;
	
	public static ChatManager getChatManager()
	{
		if (chatManager == null)
		{
			chatManager = new ChatManager();
		}
		return chatManager;
	}
	
	/**
	 * 根据客户编号返回模块管理者
	 * 
	 * @param clientId
	 *            客户编号
	 * @return 模块管理者
	 */
	public static ModulesManager getModulesManager(int clientId)
	{
		Client client = getClient(clientId);
		if (client == null)
			return null;
		return client.getModulesManager();
	}

	/**
	 * 根据客户编号返回登录管理者
	 * 
	 * @param clientId
	 *            客户编号
	 * @return 登录管理者
	 */
	public static LoginManager getLoginManager(int clientId)
	{
		ModulesManager modulesManager = getModulesManager(clientId);
		if (modulesManager == null)
			return null;
		return modulesManager.getLoginManager();
	}

	/**
	 * 根据客户编号获取socket管理者
	 * 
	 * @param clientId
	 *            客户编号
	 * @return socket管理者
	 */
	public static SocketManager getSocketManager(int clientId)
	{
		Client client = getClient(clientId);
		if (client == null)
			return null;
		return client.getSocketManager();
	}

	/**
	 * 获取协议编写者
	 * 
	 * @param clientId
	 *            客户编号
	 * @return 协议编写者
	 */
	public static DataOutputStream getWriter(int clientId)
	{
		SocketManager socketManager = getSocketManager(clientId);
		if (socketManager == null)
			return null;
		return socketManager.getWriter();
	}

	/**
	 * 获取协议发送者
	 * 
	 * @param clientId
	 *            客户编号
	 * @return 协议发送者
	 */
	public static MsgSender getMsgSender(int clientId)
	{
		Client client = getClient(clientId);
		if (client == null)
			return null;
		return client.getMsgSender();
	}

	/**
	 * 获取协议处理者
	 * 
	 * @param clientId
	 *            客户编号
	 * @return 协议处理者
	 */
	public static MsgProcessor getMsgProcessor(int clientId)
	{
		Client client = getClient(clientId);
		if (client == null)
			return null;
		return client.getMsgProcessor();
	}
}
