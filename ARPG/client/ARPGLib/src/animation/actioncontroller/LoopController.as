package animation.actioncontroller
{
	import animation.AnimationController;
	import animation.AnimationEvent;

	[Event(name = "looped", type = "animation.AnimationEvent")]
	/**
	 * 循环动画控制
	 * @author warden_feng 2013-6-7
	 */
	public class LoopController extends AnimationController
	{
		public function LoopController()
		{
			super();
		}

		override public function set totalFrame(value:int):void
		{
			super.totalFrame = value;
			animationAction.frames = [];
			for (var i:int = 1; i <= value; i++)
			{
				animationAction.frames.push(i);
			}
		}

		override public function enterFrame():void
		{
			if (shownum == 0)
			{
				indexFrame++
				if (indexFrame == animationAction.frames.length - 1)
					dispatchEvent(new AnimationEvent(AnimationEvent.LOOPED));
				if (indexFrame < 0 || indexFrame >= animationAction.frames.length)
				{
					indexFrame = 0;
				}
			}
			shownum = (shownum + 1) % 4;
			super.enterFrame();
		}

	}
}
