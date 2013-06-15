package com.feng.components
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	public class FVScrollSlider extends FScrollSlider
	{
		private static var instanceDic:Dictionary = new Dictionary();

		public static function getInstance(vScrollSliderMc:MovieClip):FVScrollSlider
		{
			if (instanceDic[vScrollSliderMc] == null)
			{
				instanceDic[vScrollSliderMc] = new FVScrollSlider(vScrollSliderMc);
			}
			return instanceDic[vScrollSliderMc];
		}

		public function FVScrollSlider(vScrollSliderMc:MovieClip)
		{
			super(vScrollSliderMc, FSlider.VERTICAL);
		}
	}
}
