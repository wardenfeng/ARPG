package feng.sql.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;
import org.hibernate.classic.Session;

import feng.sql.dao.MonsterDao;
import feng.sql.model.Monster;

/**
 * 
 * @author warden_feng 2013-6-28
 */
public class MonsterDaoImpl implements MonsterDao
{
	private static SessionFactory sf;

	static
	{
		sf = new AnnotationConfiguration().configure().buildSessionFactory();
	}

	@Override
	public Monster getById(int id)
	{
		Session session = sf.openSession();
		session.beginTransaction();
		Monster monster = (Monster) session.get(Monster.class, id);
		session.getTransaction().commit();
		session.close();
		return monster;
	}

	@Override
	public List<Monster> getMonsters()
	{
		Session session = sf.openSession();
		session.beginTransaction();
		Query query = session.createQuery("from Monster");
		@SuppressWarnings("unchecked")
		List<Monster> list = query.list();
		session.getTransaction().commit();
		session.close();
		return list;
	}
}
