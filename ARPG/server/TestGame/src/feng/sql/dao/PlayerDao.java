package feng.sql.dao;

import feng.sql.model.Player;

/**
 * player表操作类
 * @author 风之守望者	2011-11-11
 */
public interface PlayerDao
{
	Player getById(int id);
	Player getByName(String name);
	void save(Player player);
	void update(Player player);
}
