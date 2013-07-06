package modules.gamescene
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 *
	 * @author warden feng 2013-6-4
	 */
	public class GameScene
	{
		private static var gameSceneManager:GameSceneManager;

		public static function init():void
		{
			gameSceneManager || (gameSceneManager = new GameSceneManager());
		}
		
		/** 场景物件层 */
		public static var sceneItemLayer:Sprite;
		
		public static var playerDic:Dictionary = new Dictionary();
		
		public static var monsterDic:Dictionary = new Dictionary();
		
		/** 场景上物件 */
		public static var sceneItems:Array = [];
		
		public static var playerList:Array = [];
		
		public static var monsterList:Array = [];
		
		public static var npcList:Array = [];
		
		public static var skillEffects:Array = [];
	}
}
