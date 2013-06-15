package com.feng.components
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	public class FVSlider extends FSlider
	{
		private static var instanceDic:Dictionary = new Dictionary();
		
		public static function getInstance(vSliderMc:MovieClip):FVSlider
		{
			if (instanceDic[vSliderMc] == null)
			{
				instanceDic[vSliderMc] = new FVSlider(vSliderMc);
			}
			return instanceDic[vSliderMc];
		}
		
		public function FVSlider(vSliderMc:MovieClip)
		{
			super(vSliderMc, FSlider.VERTICAL);
		}
	}
}