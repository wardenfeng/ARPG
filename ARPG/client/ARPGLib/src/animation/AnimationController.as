package animation
{
	import flash.events.EventDispatcher;

	[Event(name = "change", type = "animation.AnimationEvent")]
	/**
	 * 动画控制
	 * @author warden feng 2013-6-7
	 */
	public class AnimationController extends EventDispatcher
	{
		public var indexFrame:int = 0;

		//用来控制帧播放频率
		protected var shownum:int = 1;

		protected var _animationAction:AnimationAction;

		protected var _totalFrame:int;

		public function AnimationController()
		{
			animationAction = new AnimationAction();
		}

		public function enterFrame():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.CHANGE));
		}

		public function get totalFrame():int
		{
			return _totalFrame;
		}

		public function set totalFrame(value:int):void
		{
			_totalFrame = value;
		}

		public function get turned():Boolean
		{
			if (animationAction)
				return animationAction.turned;
			return false;
		}

		/** 当前帧 */
		public function get currentFrame():int
		{
			if (animationAction && animationAction.frames)
				return animationAction.frames[indexFrame];
			return 1;
		}

		public function get animationAction():AnimationAction
		{
			return _animationAction;
		}

		public function set animationAction(value:AnimationAction):void
		{
			_animationAction = value;
		}

	}
}
