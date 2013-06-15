package com.feng.components
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	public class FVScrollBar extends FScrollBar
	{
		private static var instanceDic:Dictionary = new Dictionary();

		public static function getInstance(vScrollBarMc:MovieClip):FVScrollBar
		{
			if (instanceDic[vScrollBarMc] == null)
			{
				instanceDic[vScrollBarMc] = new FVScrollBar(vScrollBarMc);
			}
			return instanceDic[vScrollBarMc];
		}

		public function FVScrollBar(vScrollBarMc:MovieClip)
		{
			super(vScrollBarMc, FSlider.VERTICAL);
		}
	}
}