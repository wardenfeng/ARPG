package feng.sql.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 * @author 风之守望者 2013-6-20
 */

@Entity
@Table(name = "monsterconfig")
public class MonsterConfig
{
	private int id;
	private int typeId; // 类型编号，怪物类型
	private int HP;
	private int mapX;
	private int mapY;

	@Id
	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public int getTypeId()
	{
		return typeId;
	}

	public void setTypeId(int typeId)
	{
		this.typeId = typeId;
	}

	public int getHP()
	{
		return HP;
	}

	public void setHP(int hP)
	{
		HP = hP;
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
}
