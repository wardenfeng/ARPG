package animation.animationtypes
{
	import animation.AnimationItemFactory;

	/**
	 * NPC动画
	 * @author warden feng 2013-6-14
	 */
	public class NPCAnimation extends LoopAnimation
	{
		protected var _mid:String;

		public function NPCAnimation(mid:String)
		{
			this.mid = mid;
			init();
		}

		public function get mid():String
		{
			return _mid;
		}

		public function set mid(value:String):void
		{
			if (_mid != value)
			{
				var url:String = GlobalData.getNPCPath(value);

				animationItem = AnimationItemFactory.getAnimationItem(url);
			}
			_mid = value;
		}
		
		public function set turned(value:Boolean):void
		{
			loopController.animationAction.turned = value;
		}
	}
}
