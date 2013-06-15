package com.feng.components
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	public class FHScrollBar extends FScrollBar
	{
		private static var instanceDic:Dictionary = new Dictionary();

		public static function getInstance(hScrollBarMc:MovieClip):FHScrollBar
		{
			if (instanceDic[hScrollBarMc] == null)
			{
				instanceDic[hScrollBarMc] = new FHScrollBar(hScrollBarMc);
			}
			return instanceDic[hScrollBarMc];
		}

		public function FHScrollBar(hScrollBarMc:MovieClip)
		{
			super(hScrollBarMc, FSlider.HORIZONTAL);
		}
	}
}