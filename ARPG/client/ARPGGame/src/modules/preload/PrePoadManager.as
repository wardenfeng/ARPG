package modules.preload
{
	import modules.GameDispatcher;
	import modules.ModulesManager;
	import modules.load.LoadEvent;

	/**
	 *
	 * @author warden feng 2013-6-14
	 */
	public class PrePoadManager extends ModulesManager
	{
		private var urls:Array;

		private var loadings:Array;

		public function PrePoadManager()
		{
			urls = ["view/uilibrary.swf"];

			for (var i:int = 0; i < urls.length; i++)
			{
				urls[i] = GlobalData.rootPath + urls[i];
			}

			loadings = urls.concat();

			var loadData:Object = {urls: urls, singleComplete: singleComplete, singleCompleteParam: {}, allItemsLoaded: completeHandler};

			GameDispatcher.instance.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, loadData));
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
			logger("资源预先加载完成。");
		}
	}
}
