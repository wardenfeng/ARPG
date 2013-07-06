package animation.animationtypes
{
	import animation.AnimationItemFactory;
	import animation.actioncontroller.MonsterController;

	/**
	 * 怪物动画
	 * @author warden feng 2013-6-14
	 */
	public class MonsterAnimation extends LoopAnimation
	{
		protected var _mid:String;

		private static var _defaultAnimation:MonsterAnimation;
		
		public static function get defaultAnimation():MonsterAnimation
		{
			if(_defaultAnimation == null)
			{
				_defaultAnimation = new MonsterAnimation("1001");
			}
			return _defaultAnimation;
		}
		
		public function MonsterAnimation(mid:String)
		{
			this.mid = mid;

			monsterController = new MonsterController();
		}

		public function get monsterController():MonsterController
		{
			return loopController as MonsterController;
		}

		public function set monsterController(value:MonsterController):void
		{
			loopController = value;
		}

		public function get mid():String
		{
			return _mid;
		}

		public function set mid(value:String):void
		{
			if (_mid != value)
			{
				var url:String = GlobalData.getMonsterPath(value);

				animationItem = AnimationItemFactory.getAnimationItem(url);
			}
			_mid = value;
		}
	}
}
