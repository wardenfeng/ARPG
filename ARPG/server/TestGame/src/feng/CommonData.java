package feng;


import java.util.Map;

import feng.client.Client;



/**
 * 
 * @author 风之守望者 2011-11-4
 */
public class CommonData
{
	/** 连接到服务器的客户 */
	public static Map<Integer,Client> connectedClientMap;
	
	/** 登录成功的客户 */
	public static Map<Integer,Client> loginedClientMap;
	
}