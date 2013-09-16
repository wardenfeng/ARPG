package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import modules.GameDispatcher;

	/**
	 *
	 * @author warden_feng 2013-7-29
	 */
	public class Game extends Sprite
	{
		private var dispatcher:GameDispatcher = GameDispatcher.instance;

		public function Game()
		{
			var menu0:ContextMenuItem = new ContextMenuItem("ARPG\t" + GlobalData.VERSION, true, true, true);
			var viewContextMenu:ContextMenu = new ContextMenu();
			viewContextMenu.customItems = [menu0];
			contextMenu = viewContextMenu;

			var mask:Shape = new Shape();
			this.mask = mask;
			mask.graphics.beginFill(0xff0000);
			mask.graphics.drawRect(0,0,UIAllRefer.gameWidth,UIAllRefer.gameHeight);
			mask.graphics.endFill();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}

		protected function onAddToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);

			this.stage.tabChildren = false;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;

			UIAllRefer.game = this;
			initLayers();
		}

		private function initLayers():void
		{
			UIAllRefer.backLayer.name = "backLayer";
			this.addChild(UIAllRefer.backLayer);
			UIAllRefer.sceneLayer.name = "sceneLayer";
			this.addChild(UIAllRefer.sceneLayer);
			UIAllRefer.contentLayer.name = "contentLayer";
			this.addChild(UIAllRefer.contentLayer);
			UIAllRefer.promptBoxLayer.name = "promptBoxLayer";
			this.addChild(UIAllRefer.promptBoxLayer);
			UIAllRefer.infoLayer.name = "infoLayer";
			this.addChild(UIAllRefer.infoLayer);
			UIAllRefer.tooltipLayer.name = "tooltipLayer";
			this.addChild(UIAllRefer.tooltipLayer);
		}
	}
}
