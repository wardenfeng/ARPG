package feng.sql.dao;

import java.util.List;

import feng.sql.model.MonsterConfig;

/**
 * 
 * @author 风之守望者 2013-6-28
 */
public interface MonsterConfigDao
{
	public MonsterConfig getById(int id);

	public List<MonsterConfig> getConfigs();
}