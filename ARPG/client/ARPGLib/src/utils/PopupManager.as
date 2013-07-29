package utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	/**
	 * ui管理类
	 * PopUpManager singleton 类用于创建新的顶级窗口，还可以在位于所有其他可见窗口上面的层次中放置或删除这些窗口。
	 * @author warden feng 2013-7-25
	 */
	public class PopupManager
	{
		public static function addPopUp(window:DisplayObject, parent:DisplayObjectContainer, center:Boolean = false, modal:Boolean = false):void
		{
			if (modal)
			{
				UIAllRefer.stage.addChild(window);
				UIAllRefer.game.mouseEnabled = false;
				UIAllRefer.game.mouseChildren = false;
				window.addEventListener(Event.REMOVED_FROM_STAGE, function(event:Event):void
				{
					UIAllRefer.game.mouseEnabled = true;
					UIAllRefer.game.mouseChildren = true;
				});
			}
			else
			{
				parent.addChild(window);
			}
			center && centerPopUp(window);
		}

		public static function centerPopUp(popUp:DisplayObject):void
		{
			popUp.x = (UIAllRefer.stage.stageWidth - popUp.width) / 2;
			popUp.y = (UIAllRefer.stage.stageHeight - popUp.height) / 2;
		}
		
		public static function removePopUp(popUp:DisplayObject):void
		{
			popUp.parent && popUp.parent.removeChild(popUp);
		}

		public static function addTooltip(window:DisplayObject, center:Boolean = false, modal:Boolean = false):void
		{
			addPopUp(window, UIAllRefer.tooltipLayer, center, modal);
		}

		public static function addPromptBox(window:DisplayObject, center:Boolean = false, modal:Boolean = false):void
		{
			addPopUp(window, UIAllRefer.promptBoxLayer, center, modal);
		}

		public static function addContentUI(window:DisplayObject, center:Boolean = false, modal:Boolean = false):void
		{
			addPopUp(window, UIAllRefer.contentLayer, center, modal);
		}
	}
}
