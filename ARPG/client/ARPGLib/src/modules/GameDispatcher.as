package modules
{
	import flash.events.EventDispatcher;

	/**
	 * 游戏事件适配器
	 * @author xumin.xu
	 *
	 */
	public class GameDispatcher extends EventDispatcher
	{
		private static var randomNumber:Number = Math.random();

		public function GameDispatcher(number:Number)
		{
			if (number != randomNumber)
			{
				throw new Error("此类不允许外部创建，请用instance属性！");
			}
		}

		private static var _instance:GameDispatcher;

		public static function get instance():GameDispatcher
		{
			_instance || (_instance = new GameDispatcher(randomNumber));
			return _instance;
		}
	}
}
