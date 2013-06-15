package com.feng.components
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	public class FHSlider extends FSlider
	{
		private static var instanceDic:Dictionary = new Dictionary();

		public static function getInstance(hSliderMc:MovieClip):FHSlider
		{
			if (instanceDic[hSliderMc] == null)
			{
				instanceDic[hSliderMc] = new FHSlider(hSliderMc);
			}
			return instanceDic[hSliderMc];
		}

		public function FHSlider(hSliderMc:MovieClip)
		{
			super(hSliderMc, FSlider.HORIZONTAL);
		}
	}
}