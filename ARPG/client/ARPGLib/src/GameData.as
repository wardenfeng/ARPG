package
{
	import flash.utils.Dictionary;

	/**
	 *
	 * @author warden feng 2013-6-13
	 */
	public class GameData
	{
		public static var playerDic:Dictionary = new Dictionary();

		public static var monsterDic:Dictionary = new Dictionary();
		
		public static var NPCNameDic:Dictionary;

		public static var modelInfoDic:Dictionary;

		public static var modelDic:Dictionary;
		
		public static var enemyDic:Dictionary;
		
		/** 释放中的技能字典 */
		public static var castingSkillDic:Dictionary = new Dictionary();
	}
}
