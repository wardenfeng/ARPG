package feng.config;

import java.util.List;

import feng.sql.SQLManager;
import feng.sql.model.Monster;
import feng.sql.model.MonsterConfig;

/**
 * 
 * @author warden_feng 2013-6-20
 */
public class MonsterManager
{
	/** 怪物配置 */
	public static List<MonsterConfig> monsterConfigList;

	public static List<Monster> monsterList;

	public static void init()
	{
		monsterConfigList = SQLManager.getInstance().getMonsterConfigDao().getConfigs();
		monsterConfigList.size();

		monsterList = SQLManager.getInstance().getMonsterDao().getMonsters();
		monsterList.size();
	}
}