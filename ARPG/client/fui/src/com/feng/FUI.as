package com.feng
{
	import com.feng.components.FButton;
	import com.feng.components.FHScrollBar;
	import com.feng.components.FHSlider;
	import com.feng.components.FList;
	import com.feng.components.FVScrollBar;
	import com.feng.components.FVSlider;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;

	public class FUI
	{
		public function FUI()
		{
		}

		private static const BUTTON_SIGN:String = "Btn";

		private static const HSlider_SIGN:String = "HSlider";

		private static const VSlider_SIGN:String = "VSlider";

		private static const HScrollBar_SIGN:String = "HScrollBar";

		private static const VScrollBar_SIGN:String = "VScrollBar";

		private static const List_SIGN:String = "List";

		public static function init(stage:Stage):void
		{
			stage.addEventListener(Event.ADDED, onAdded);
		}

		protected static function onAdded(event:Event):void
		{
			var mc:MovieClip = event.target as MovieClip;
			mc && make(mc);
		}

		/** 检查mc中使用的组件 （未完待续） */
		private static function make(mc:MovieClip):void
		{
			var childMc:MovieClip;
			for (var i:int = 0; i < mc.numChildren; i++)
			{
				childMc = mc.getChildAt(i) as MovieClip;
				if (childMc)
				{
					if (childMc.name.substring(childMc.name.length - BUTTON_SIGN.length) == BUTTON_SIGN)
					{
						FButton.getInstance(childMc);
					}
					else if (childMc.name.substring(childMc.name.length - HSlider_SIGN.length) == HSlider_SIGN)
					{
						FHSlider.getInstance(childMc);
					}
					else if (childMc.name.substring(childMc.name.length - VSlider_SIGN.length) == VSlider_SIGN)
					{
						FVSlider.getInstance(childMc);
					}
					else if (childMc.name.substring(childMc.name.length - HScrollBar_SIGN.length) == HScrollBar_SIGN)
					{
						FHScrollBar.getInstance(childMc);
					}
					else if (childMc.name.substring(childMc.name.length - VScrollBar_SIGN.length) == VScrollBar_SIGN)
					{
						FVScrollBar.getInstance(childMc);
					}
					else if (childMc.name.substring(childMc.name.length - List_SIGN.length) == List_SIGN)
					{
						FList.getInstance(childMc);
					}
					else
					{
						make(childMc);
					}
				}
			}

		}
	}
}
