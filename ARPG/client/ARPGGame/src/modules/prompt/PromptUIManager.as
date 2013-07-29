package modules.prompt
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import communication.arpg.ArpgMsgEvent;

	import modules.ModulesManager;
	import modules.load.Load;
	import modules.load.LoadEvent;

	import utils.PopupManager;

	public class PromptUIManager extends ModulesManager
	{
		private var urls:Array;

		private var loadings:Array;

		private const breaktipPath:String = GlobalData.rootPath + "resources/view/breaktip.swf";

		/**
		 * 提示界面管理类
		 * @author warden feng 2013-7-25
		 */
		public function PromptUIManager()
		{
			urls = [ //
				breaktipPath, //
				];

			loadings = urls.concat();

			var loadData:Object = {urls: urls, singleComplete: singleComplete, singleCompleteParam: {}, allItemsLoaded: completeHandler};

			dispatcher.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, loadData));

			addListeners();
		}

		private function singleComplete(param:Object):void
		{
			var index:int = loadings.indexOf(param.url);
			if (index != -1)
			{
				loadings.splice(index, 1);
			}
			logger((urls.length - loadings.length) + "/" + urls.length);
		}

		public function completeHandler():void
		{
			logger("提示资源加载完成。");
			Prompt.isPromptResCompleted = true;
		}

		private function addListeners():void
		{
			dispatcher.addEventListener(ArpgMsgEvent.LOST_CONNECTION, onLostConnection);
		}

		private function onLostConnection(event:Event):void
		{
			var promptUI:MovieClip = Load.getInstance("breakTip");
			promptUI.name = "breakTip";
			PopupManager.addPromptBox(promptUI, true, true);

			promptUI.addEventListener(MouseEvent.CLICK, function(event:Event):void
			{
				PopupManager.removePopUp(promptUI);
			});
		}
	}
}
