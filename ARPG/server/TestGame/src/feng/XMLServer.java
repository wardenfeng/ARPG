package feng;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

/**
 * 
 * @author warden_feng 2013-6-2
 */
public class XMLServer extends Thread
{
	private ServerSocket serverSocket;

	@Override
	public void run()
	{
		String xml = "<cross-domain-policy>";
		xml = xml + "<allow-access-from domain=\"*\" to-ports=\"*\" />";
		xml = xml + "</cross-domain-policy>";

		try
		{
			serverSocket = new ServerSocket(843);
		}
		catch (IOException e1)
		{
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		while (true)
		{
			try
			{
				// 新建一个连接
				Socket socket = serverSocket.accept();
				System.out.println("连接成功......");
				BufferedReader br = new BufferedReader(new InputStreamReader(socket.getInputStream()));
				PrintWriter pw = new PrintWriter(socket.getOutputStream());
				// 接收用户名
				char[] by = new char[22];
				br.read(by, 0, 22);
				String head = new String(by);
				System.out.println("消息头:" + head + ":");
				if (head.equals("<policy-file-request/>"))
				{
					pw.print(xml + "\0");
					pw.flush();
				}
				/*
				 * else { ServerThread thread = new ServerThread(socket);
				 * thread.start(); }
				 */
			}
			catch (Exception e)
			{
				System.out.println("服务器出现异常！" + e);
			}
		}
	}
}