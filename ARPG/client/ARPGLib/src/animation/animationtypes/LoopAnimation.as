package animation.animationtypes
{
	import animation.Animation;
	import animation.AnimationEvent;
	import animation.AnimationItem;
	import animation.actioncontroller.LoopController;

	[Event(name = "looped", type = "animation.AnimationEvent")]

	/**
	 * 循环动画
	 * @author warden feng 2013-6-7
	 */
	public class LoopAnimation extends Animation
	{
		public function LoopAnimation()
		{
			init();
		}

		protected function init():void
		{
			loopController = new LoopController();
		}

		public function set loopController(value:LoopController):void
		{
			if (_animationController)
			{
				_animationController.removeEventListener(AnimationEvent.CHANGE, onControllerChange);
				_animationController.removeEventListener(AnimationEvent.LOOPED, onControllerLooped);
			}
			_animationController = value;
			_animationController.addEventListener(AnimationEvent.CHANGE, onControllerChange);
			_animationController.addEventListener(AnimationEvent.LOOPED, onControllerLooped);

			if (animationItem)
				_animationController.totalFrame = animationItem.totalFrame;
		}

		public function get loopController():LoopController
		{
			return _animationController as LoopController;
		}

		override public function set animationItem(value:AnimationItem):void
		{
			super.animationItem = value;
			if (loopController)
				_animationController.totalFrame = animationItem.totalFrame;
		}

		protected function onControllerLooped(event:AnimationEvent):void
		{
			dispatchEvent(event);
		}
	}
}
