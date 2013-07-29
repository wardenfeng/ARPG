package feng;


import java.util.Map;

import feng.client.Client;



/**
 * 
 * @author warden_feng 2011-11-4
 */
public class CommonData
{
	/** 连接到服务器的客户 */
	public static Map<Integer,Client> connectedClientMap;
	
	/** 登录成功的客户 */
	public static Map<Integer,Client> loginedClientMap;
	
	/** 玩家编号，客户端编号 */
	public static Map<Integer,Integer> playerClientMap;
	
	
}