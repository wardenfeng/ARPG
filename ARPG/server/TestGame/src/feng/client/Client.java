package feng.client;

import java.net.Socket;

import feng.MsgProcessor;
import feng.MsgSender;
import feng.modules.ModulesManager;
import feng.network.SocketManager;
import feng.sql.SQLManager;

/**
 * 客户（玩家所以数据与操作）
 * 
 * @author 风之守望者 2011-11-4
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

	/** 数据库管理者 */
	private SQLManager sqlManager;

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

	public SQLManager getSqlManager()
	{
		if (sqlManager == null)
		{
			sqlManager = new SQLManager();
		}
		return sqlManager;
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