package feng.network;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.Socket;
import java.nio.ByteBuffer;

import feng.AllReference;
import feng.CommonData;
import feng.MsgProcessor;
import feng.modules.LogoutManager;

/**
 * socket管理者
 * 
 * @author 风之守望者 2011-11-23
 */
public class SocketManager extends Thread
{
	public static final int HEADER_LENGTH = 4;

	public static final int MAGIC_NUMBER_LENGTH = 4;

	public static final int MESSAGE_ID_LENGTH = 4;

	public static final int DESCRIPTION_LENGTH = HEADER_LENGTH + MESSAGE_ID_LENGTH + MAGIC_NUMBER_LENGTH;

	public static final int MAGIC_NUMBER = 0x98765432;

	private Socket socket;

	private DataInputStream reader;

	private DataOutputStream writer;

	private MsgProcessor msgProcessor;

	private int clientId;

	public SocketManager(int clientId, Socket socket)
	{
		super();
		this.clientId = clientId;
		this.socket = socket;
		try
		{
			// 获得输入流和输出流，输入流为 BufferedReader 类型，输出流为 DataOutputStream 类型
			reader = new DataInputStream(socket.getInputStream());
			writer = new DataOutputStream(socket.getOutputStream());
			msgProcessor = AllReference.getMsgProcessor(clientId);
		}
		catch (UnsupportedEncodingException e)
		{
			e.printStackTrace();
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}
	}

	@Override
	public void run()
	{

		while (true)
		{
			try
			{
				ByteBuffer inputByteBuffer = ByteBuffer.allocate(1024);
				int inputLen = inputByteBuffer.position();
				// 协议的长度
				while (inputLen < HEADER_LENGTH)
				{
					inputByteBuffer.put(reader.readByte());
					inputLen = inputByteBuffer.position();
				}
				inputByteBuffer.position(0);
				int protocolLength = inputByteBuffer.getInt();

				// 协议号
				while (inputLen < protocolLength)
				{
					inputByteBuffer.put(reader.readByte());
					inputLen = inputByteBuffer.position();
				}
				inputByteBuffer.position(HEADER_LENGTH + MAGIC_NUMBER_LENGTH);
				int protocalId = inputByteBuffer.getInt();

//				System.out.println("收到协议：协议长度：" + protocolLength + ",协议号：" + protocalId);

				ByteBuffer byteBuffer = ByteBuffer.allocate(protocolLength - (DESCRIPTION_LENGTH));
				byteBuffer.put(inputByteBuffer.array(), DESCRIPTION_LENGTH, protocolLength - DESCRIPTION_LENGTH);

				Protocol.Decode(protocalId, byteBuffer, msgProcessor);
			}
			catch (IOException e)
			{
				System.out.println("客户端断开连接");
//				 e.printStackTrace();
				break;
			}
		}

		LogoutManager logoutManager = AllReference.getLogoutManager();
		logoutManager.disconnect(clientId);

		try
		{
			socket.close();
			CommonData.connectedClientMap.remove(clientId);
		}
		catch (IOException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public DataOutputStream getWriter()
	{
		return writer;
	}

	public Socket getSocket()
	{
		return socket;
	}

	public void setSocket(Socket socket)
	{
		this.socket = socket;
	}
}
