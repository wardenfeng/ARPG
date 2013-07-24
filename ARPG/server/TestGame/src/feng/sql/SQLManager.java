package feng.sql;

import feng.sql.dao.MonsterConfigDao;
import feng.sql.dao.MonsterDao;
import feng.sql.dao.PlayerDao;
import feng.sql.dao.impl.MonsterConfigDaoImpl;
import feng.sql.dao.impl.MonsterDaoImpl;
import feng.sql.dao.impl.PlayerDaoImpl;

/**
 * 
 * @author 风之守望者 2011-11-12
 */
public class SQLManager
{
	/** 数据库管理者 */
	private static SQLManager sqlManager;

	public static SQLManager getInstance()
	{
		if (sqlManager == null)
		{
			sqlManager = new SQLManager();
		}
		return sqlManager;
	}

	private PlayerDao playerDao;

	/**
	 * 获取player表的操作类
	 */
	public PlayerDao getPlayerDao()
	{
		if (playerDao == null)
		{
			playerDao = new PlayerDaoImpl();
		}
		return playerDao;
	}

	private MonsterConfigDao monsterConfigDao;

	public MonsterConfigDao getMonsterConfigDao()
	{
		if (monsterConfigDao == null)
		{
			monsterConfigDao = new MonsterConfigDaoImpl();
		}
		return monsterConfigDao;
	}

	private MonsterDao monsterDao;

	public MonsterDao getMonsterDao()
	{
		if (monsterDao == null)
		{
			monsterDao = new MonsterDaoImpl();
		}
		return monsterDao;
	}
}
