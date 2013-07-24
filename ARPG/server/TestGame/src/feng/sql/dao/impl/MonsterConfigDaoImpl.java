package feng.sql.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;
import org.hibernate.classic.Session;

import feng.sql.dao.MonsterConfigDao;
import feng.sql.model.MonsterConfig;

/**
 * 
 * @author 风之守望者 2013-6-28
 */
public class MonsterConfigDaoImpl implements MonsterConfigDao
{
	private static SessionFactory sf;

	static
	{
		sf = new AnnotationConfiguration().configure().buildSessionFactory();
	}

	@Override
	public MonsterConfig getById(int id)
	{
		Session session = sf.openSession();
		session.beginTransaction();
		MonsterConfig monsterconfig = (MonsterConfig) session.get(MonsterConfig.class, id);
		session.getTransaction().commit();
		session.close();
		return monsterconfig;
	}

	@Override
	public List<MonsterConfig> getConfigs()
	{
		Session session = sf.openSession();
		session.beginTransaction();
		Query query = session.createQuery("from MonsterConfig");
		@SuppressWarnings("unchecked")
		List<MonsterConfig> list = query.list();
		session.getTransaction().commit();
		session.close();
		return list;
	}
}
