package animation
{
	import flash.display.Bitmap;
	import flash.geom.Point;

	[Event(name = "change", type = "animation.AnimationEvent")]
	/**
	 *
	 * @author warden_feng 2013-6-7
	 */
	public class Animation extends Bitmap implements ISceneItem
	{
		protected var _animationItem:AnimationItem;

		protected var _animationFrame:AnimationFrame;

		/** 地面上的坐标X */
		protected var _floorX:Number = 0;

		/** 地面上的坐标Y */
		protected var _floorY:Number = 0;

		protected var _animationController:AnimationController;

		public function Animation()
		{

		}

		protected function onChange(event:AnimationEvent):void
		{
			animationController.totalFrame = animationItem.totalFrame;
			update();
		}

		protected function onControllerChange(event:AnimationEvent):void
		{
			update();
			dispatchEvent(event);
		}

		protected function update():void
		{
			if (animationItem && animationController)
				animationFrame = animationItem.getAnimationFrame(animationController.currentFrame, animationController.turned);
		}

		protected function get animationFrame():AnimationFrame
		{
			return _animationFrame;
		}

		protected function set animationFrame(value:AnimationFrame):void
		{
			_animationFrame = value;
			if (_animationFrame == null)
				return;
			bitmapData = _animationFrame.bitmapdata;
			x = _floorX + animationFrame.x;
			y = _floorY + animationFrame.y;
		}

		public function get floorX():Number
		{
			return _floorX;
		}

		public function set floorX(value:Number):void
		{
			_floorX = value;
			x = animationFrame == null ? _floorX : _floorX + animationFrame.x;
		}

		public function get floorY():Number
		{
			return _floorY;
		}

		public function set floorY(value:Number):void
		{
			_floorY = value;
			x = animationFrame == null ? _floorY : _floorY + animationFrame.y;
		}

		/** 地面上的坐标 */
		public function get floorPoint():Point
		{
			return new Point(floorX, floorY);
		}

		/**
		 * @private
		 */
		public function set floorPoint(value:Point):void
		{
			floorX = value.x;
			floorY = value.y;
		}

		public function get animationItem():AnimationItem
		{
			return _animationItem;
		}

		public function set animationItem(value:AnimationItem):void
		{
			if (_animationItem)
			{
				animationItem.removeEventListener(AnimationEvent.CHANGE, onChange);
			}
			_animationItem = value;
			_animationItem.addEventListener(AnimationEvent.CHANGE, onChange);
		}

		public function get animationController():AnimationController
		{
			return _animationController;
		}

		public function set animationController(value:AnimationController):void
		{
			if (_animationController)
			{
				_animationController.removeEventListener(AnimationEvent.CHANGE, onControllerChange);
			}
			_animationController = value;
			_animationController.addEventListener(AnimationEvent.CHANGE, onControllerChange);
		}

	}
}
