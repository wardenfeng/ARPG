package feng;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashMap;

import feng.client.Client;

/**
 * 
 * @author 风之守望者 2011-11-4
 */
public class GameServer
{
	/**
	 * 开启服务器入口
	 */
	public static void main(String[] args)
	{
		//flash 访问java的socket交互安全策略问题
		try
		{
			new XMLServer().start();
		}
		catch (Exception e)
		{
			System.out.println("socket异常:" + e);
		}
		
		// 启动游戏服务器socket
		ServerSocket socketServer;
		try
		{
			socketServer = new ServerSocket(8887);
			System.out.println("服务器已启动，等待客户连接");
			CommonData.connectedClientMap = new HashMap<Integer, Client>();
			CommonData.loginedClientMap = new HashMap<Integer, Client>();
			CommonData.playerClientMap = new HashMap<Integer, Integer>();

			while (true)
			{
				// accept() 方法是阻塞式的，当有客户连接成功后才继续执行
				Socket socket = socketServer.accept();
				System.out.println("客户连接成功");

				// 实例化一个 Client 对象，并启动该线程
				ClientFactory.createClient(socket);
			}
		} catch (IOException e)
		{
			e.printStackTrace();
			
		}
	}

}