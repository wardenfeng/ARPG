package feng.dao.impl;

import org.junit.Test;

import feng.sql.dao.MonsterConfigDao;
import feng.sql.dao.impl.MonsterConfigDaoImpl;

/**
 * 
 * @author warden_feng 2013-6-28
 */
public class MonsterConfigDaoImplTest
{

	@Test
	public void testGetConfigs()
	{
		MonsterConfigDao monsterConfigDao = new MonsterConfigDaoImpl();
		
//		monsterConfigDao.getById(1);
		
		monsterConfigDao.getConfigs();
		
		
		
	}

}
