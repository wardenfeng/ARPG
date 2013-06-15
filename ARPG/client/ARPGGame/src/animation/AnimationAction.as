package animation
{

	/**
	 * 动作数据
	 * @author warden feng 2013-6-7
	 */
	public class AnimationAction
	{
		private var _frames:Array;

		/** 是否翻转图片 */
		private var _turned:Boolean = false;

		public function AnimationAction(frames:Array = null, turned:Boolean = false)
		{
			this.frames = frames;
			_turned = turned;
		}

		public function get turned():Boolean
		{
			return _turned;
		}

		public function set turned(value:Boolean):void
		{
			_turned = value;
		}

		/** 帧序列 */
		public function get frames():Array
		{
			return _frames;
		}

		/**
		 * @private
		 */
		public function set frames(value:Array):void
		{
			_frames = value;
		}
	}
}
