package feng.sql.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 * @author 风之守望者 2011-11-11
 */
@Entity
@Table(name = "player")
public class Player
{
	/** 编号 */
	private int id;
	/** 名称 */
	private String username;
	/** 密码 */
	private String password;
	private int mapX;
	private int mapY;

	private String clothing;

	private int mapId;
	
	private int hp;
	
	private int mp;
	
	@Id
	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getUsername()
	{
		return username;
	}

	public void setUsername(String username)
	{
		this.username = username;
	}

	public String getPassword()
	{
		return password;
	}

	public void setPassword(String password)
	{
		this.password = password;
	}

	public int getMapX()
	{
		return mapX;
	}

	public void setMapX(int mapX)
	{
		this.mapX = mapX;
	}

	public int getMapY()
	{
		return mapY;
	}

	public void setMapY(int mapY)
	{
		this.mapY = mapY;
	}

	public String getClothing()
	{
		return clothing;
	}

	public void setClothing(String clothing)
	{
		this.clothing = clothing;
	}
	
	public int getMapId()
	{
		return mapId;
	}

	public void setMapId(int mapId)
	{
		this.mapId = mapId;
	}
	
	public int getHp()
	{
		return hp;
	}

	public void setHp(int hp)
	{
		this.hp = hp;
	}

	public int getMp()
	{
		return mp;
	}

	public void setMp(int mp)
	{
		this.mp = mp;
	}
	
}
