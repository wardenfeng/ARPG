package feng.dao.impl;

import org.junit.Test;

import feng.sql.dao.MonsterConfigDao;
import feng.sql.dao.impl.MonsterConfigDaoImpl;

/**
 * 
 * @author 风之守望者 2013-6-28
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
