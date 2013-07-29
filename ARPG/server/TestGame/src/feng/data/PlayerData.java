package feng.data;

import feng.sql.model.Player;


/**
 * 
 * @author warden_feng 2011-11-23
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