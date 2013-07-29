package feng.sql.dao;

import java.util.List;

import feng.sql.model.MonsterConfig;

/**
 * 
 * @author warden_feng 2013-6-28
 */
public interface MonsterConfigDao
{
	public MonsterConfig getById(int id);

	public List<MonsterConfig> getConfigs();
}