package feng.data;

import feng.sql.model.Player;


/**
 * 
 * @author 风之守望者 2011-11-23
 */
public class PlayerData
{
	private int clientId;

	public Player player;
	
	public PlayerData(int clientId)
	{
		this.clientId = clientId;
	}

	public int getClientId()
	{
		return clientId;
	}
}