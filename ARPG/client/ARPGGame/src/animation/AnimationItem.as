package animation
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import utils.Draw;

	[Event(name = "change", type = "animation.AnimationEvent")]
	/**
	 *
	 * @author warden feng 2013-6-6
	 */
	public class AnimationItem extends EventDispatcher
	{
		private var id:String = "";

		/** 偏移量 */
		private var geometry:Array;

		/** 资源 */
		private var bitmapdatas:Array;

		private var frameBitmapDataItemDic:Dictionary = new Dictionary();

		public function AnimationItem(id:String)
		{
			this.id = id;
		}

		public function init(geometry:Array, bitmapdatas:Array):void
		{
			this.geometry = geometry;
			this.bitmapdatas = bitmapdatas;
			dispatchEvent(new AnimationEvent(AnimationEvent.CHANGE));
		}

		public function get totalFrame():int
		{
			if (bitmapdatas == null)
				return 0;
			return bitmapdatas.length;
		}

		/**
		 * 获取帧数据
		 * @param frameIndex 帧索引
		 * @param turned 是否翻转
		 * @return
		 *
		 */
		public function getAnimationFrame(frameIndex:int, turned:Boolean = false):AnimationFrame
		{
			if (geometry == null && totalFrame == 0)
				return null;
			if (frameIndex <= 0 || frameIndex > totalFrame)
				return getAnimationFrame(1, turned);
			var animationFrame:AnimationFrame = frameBitmapDataItemDic[frameIndex + "" + turned];
			if (animationFrame)
				return animationFrame;

			animationFrame = new AnimationFrame();
			frameBitmapDataItemDic[frameIndex + "" + turned] = animationFrame;

			animationFrame.bitmapdata = bitmapdatas[frameIndex];
			if (turned)
			{
				animationFrame.bitmapdata = Draw.HorizontalTurn(animationFrame.bitmapdata);
			}

			if (turned)
			{
				animationFrame.x = -animationFrame.bitmapdata.width - geometry[frameIndex * 2 - 2];
			}
			else
			{
				animationFrame.x = geometry[frameIndex * 2 - 2];
			}
			animationFrame.y = geometry[frameIndex * 2 - 1];

			frameBitmapDataItemDic[frameIndex + "" + turned] = animationFrame;
			return animationFrame;
		}

	}
}
