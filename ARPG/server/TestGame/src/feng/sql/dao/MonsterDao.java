package feng.sql.dao;

import java.util.List;

import feng.sql.model.Monster;

/**
 * 
 * @author 风之守望者 2013-6-28
 */
public interface MonsterDao
{
	public Monster getById(int id);

	public List<Monster> getMonsters();
}