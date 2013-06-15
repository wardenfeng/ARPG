package feng;

import java.net.Socket;

import feng.client.Client;

/**
 * 
 * @author 风之守望者 2011-11-23
 */
public class ClientFactory
{
	private static int clientAutoId = 0;

	public static void createClient(Socket socket)
	{
		int clientId = getClientId();
		Client client = new Client(clientId,socket);
		CommonData.connectedClientMap.put(clientId, client);
		
		// 初始化socket管理
		client.getSocketManager().start();
		
	}

	private static int getClientId()
	{
		return clientAutoId++;
	}
}
