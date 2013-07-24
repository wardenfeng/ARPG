package feng.sql.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 * @author 风之守望者 2013-7-5
 */
@Entity
@Table(name = "monster")
public class Monster
{
	/** 编号 */
	private int id;

	private int typeId;

	private int hp;

	private int mapX;

	private int mapY;

	private boolean rebirth;

	private int rebirthmapx;

	private int rebirthmapy;

	@Id
	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public int getHp()
	{
		return hp;
	}

	public void setHp(int hp)
	{
		this.hp = hp;
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

	public int getTypeId()
	{
		return typeId;
	}

	public void setTypeId(int typeId)
	{
		this.typeId = typeId;
	}

	public boolean isRebirth()
	{
		return rebirth;
	}

	public void setRebirth(boolean rebirth)
	{
		this.rebirth = rebirth;
	}

	public int getRebirthmapx()
	{
		return rebirthmapx;
	}

	public void setRebirthmapx(int rebirthmapx)
	{
		this.rebirthmapx = rebirthmapx;
	}

	public int getRebirthmapy()
	{
		return rebirthmapy;
	}

	public void setRebirthmapy(int rebirthmapy)
	{
		this.rebirthmapy = rebirthmapy;
	}
}
