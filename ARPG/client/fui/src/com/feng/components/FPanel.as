package com.feng.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class FPanel extends FComponent
	{
		private static var instanceDic:Dictionary = new Dictionary();

		public static function getInstance(panelMc:MovieClip):FPanel
		{
			if (instanceDic[panelMc] == null)
			{
				instanceDic[panelMc] = new FPanel(panelMc);
			}
			return instanceDic[panelMc];
		}

		protected var _mask:Sprite;

		/**
		 * Container for content added to this panel. This is masked, so best to add children to content, rather than directly to the panel.
		 */
		public var content:Sprite;

		public function FPanel(panelMc:MovieClip)
		{
			super(panelMc);
		}

		override protected function addChildren():void
		{
			_mask = _skin.contentMask;
			_mask.mouseEnabled = false;

			content = _skin.content;
		}

		override public function get width():Number
		{
			return _mask.width;
		}

		override public function get height():Number
		{
			return _mask.height;
		}

	}
}
