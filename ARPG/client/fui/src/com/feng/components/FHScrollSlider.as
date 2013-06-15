package com.feng.components
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	public class FHScrollSlider extends FScrollSlider
	{
		private static var instanceDic:Dictionary = new Dictionary();

		public static function getInstance(hScrollSliderMc:MovieClip):FHScrollSlider
		{
			if (instanceDic[hScrollSliderMc] == null)
			{
				instanceDic[hScrollSliderMc] = new FHScrollSlider(hScrollSliderMc);
			}
			return instanceDic[hScrollSliderMc];
		}

		public function FHScrollSlider(hScrollSliderMc:MovieClip)
		{
			super(hScrollSliderMc, FSlider.HORIZONTAL);
		}
	}
}
