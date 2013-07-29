package feng.client;

import java.net.Socket;

import feng.MsgProcessor;
import feng.MsgSender;
import feng.modules.ModulesManager;
import feng.network.SocketManager;

/**
 * 客户（玩家所以数据与操作）
 * 
 * @author warden_feng 2011-11-4
 */
public class Client
{
	private int clientId;

	private Socket socket;

	public Client(int clientId, Socket socket)
	{
		this.clientId = clientId;
		this.socket = socket;
	}

	/** socket处理者 */
	private SocketManager socketManager;

	/** 功能处理 */
	private ModulesManager modulesManager;

	/** 协议发送者 */
	private MsgSender msgSender;

	/** 协议处理者 */
	private MsgProcessor msgProcessor;

	public int getClientId()
	{
		return clientId;
	}

	public SocketManager getSocketManager()
	{
		if (socketManager == null)
		{
			socketManager = new SocketManager(clientId, socket);
		}
		return socketManager;
	}

	public ModulesManager getModulesManager()
	{
		if (modulesManager == null)
		{
			modulesManager = new ModulesManager(clientId);
		}
		return modulesManager;
	}

	public MsgProcessor getMsgProcessor()
	{
		if (msgProcessor == null)
		{
			msgProcessor = new MsgProcessor(clientId);
		}
		return msgProcessor;
	}

	public MsgSender getMsgSender()
	{
		if (msgSender == null)
		{
			msgSender = new MsgSender(clientId);
		}
		return msgSender;
	}
}