package feng.sql.dao.impl;

import java.util.List;


import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;
import org.hibernate.classic.Session;

import feng.sql.dao.PlayerDao;
import feng.sql.model.Player;


/**
 * 
 * @author 风之守望者	2011-11-11
 */
public class PlayerDaoImpl implements PlayerDao
{

	private static SessionFactory sf;

	static {
		sf = new AnnotationConfiguration().configure().buildSessionFactory();
	}

	@Override
	public Player getById(int id) {
		Session session = sf.openSession();
		session.beginTransaction();
		Player player = (Player) session.get(Player.class, id);
		session.getTransaction().commit();
		session.close();
		return player;
	}

	@Override
	public Player getByName(String name) {
		Session session = sf.openSession();
		session.beginTransaction();
		Query q = session.createQuery("from Player p where p.username='" + name
				+ "'");
		@SuppressWarnings("unchecked")
		List<Player> players = (List<Player>) q.list();
		Player player = players.size() > 0 ? players.get(0) : null;
		session.getTransaction().commit();
		session.close();
		return player;
	}

	@Override
	public void save(Player player)
	{
		// TODO Auto-generated method stub
		Session session = sf.openSession();
		session.beginTransaction();
		session.save(player);
		session.getTransaction().commit();
		session.close();
	}

	@Override
	public void update(Player player)
	{
		// TODO Auto-generated method stub
		Session session = sf.openSession();
		session.beginTransaction();
		session.update(player);
		session.getTransaction().commit();
		session.close();
	}
}
