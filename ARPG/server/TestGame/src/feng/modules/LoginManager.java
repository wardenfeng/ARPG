package feng.modules;

import java.util.ArrayList;

import protobuf.ARPGProto.ASPKG_LOGIN_ACK.E_LOGIN_RESULT;
import feng.AllReference;
import feng.CommonData;
import feng.MsgSender;
import feng.client.Client;
import feng.data.PlayerData;
import feng.data.PlayerDataManager;
import feng.sql.dao.PlayerDao;
import feng.sql.model.Player;

/**
 * 
 * @author 风之守望者 2011-11-22
 */
public class LoginManager
{
	private int clientId;

	public LoginManager(int clientId)
	{
		this.clientId = clientId;
	}

	public void login(String username, String password)
	{
		PlayerDataManager playerDataManager = AllReference.getPlayerDataManager();

		E_LOGIN_RESULT result = E_LOGIN_RESULT.SUCCEED;

		PlayerData playerData;

		PlayerDao playerDao;
		Player player = null;
		playerDao = AllReference.getPlayerDao(clientId);
		if (playerDao == null)
		{
			result = E_LOGIN_RESULT.FAIL;
		}
		else
		{
			player = playerDao.getByName(username);
			if (player == null)
			{
				System.out.println(username + "未注册");
				result = E_LOGIN_RESULT.NO_REGISTER;
			}
			else
			{
				if (!player.getPassword().equals(password))
				{
					System.out.println(username + "使用错误密码（" + password + "）登陆");
					result = E_LOGIN_RESULT.PASSWORD_ERROR;
				}
				else
				{
					result = E_LOGIN_RESULT.SUCCEED;

					playerData = playerDataManager.createPlayerData(clientId);
					playerData.player = player;
				}
			}
		}

		MsgSender msgSender = AllReference.getMsgSender(clientId);
		msgSender.OnRecvLoginAck(result, player);

		if (result == E_LOGIN_RESULT.SUCCEED)
		{
			// 把客户添加到登录列表
			Client client = CommonData.connectedClientMap.get(clientId);
			CommonData.loginedClientMap.put(clientId, client);

			// 通知附近的玩家
			ArrayList<PlayerData> arrayList = playerDataManager.getNearPlayers(clientId);
			msgSender.OnRecvAddPlayerNtf(arrayList);

			// 广播添加玩家
			BroadcastManager broadcastManager = AllReference.getBroadcastManager();
			broadcastManager.addPlayer(clientId, player);
		}
	}
}