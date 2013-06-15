package modules.gamescene
{
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
	}
}
