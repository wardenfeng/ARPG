package modules.preload
{
	import modules.GameEvent;
	import modules.ModulesManager;
	import modules.load.Load;
	import modules.load.LoadEvent;

	/**
	 *
	 * @author warden feng 2013-6-14
	 */
	public class PrePoadManager extends ModulesManager
	{
		private var urls:Array;

		private var loadings:Array;

		private const mapDataPath:String = GlobalData.rootPath + "resources/gamedata/mapdata.swf";

		private const modelPath:String = GlobalData.rootPath + "resources/gamedata/model.swf";

		public function PrePoadManager()
		{
			urls = [ //
				GlobalData.rootPath + "resources/view/uilibrary.swf", //
				mapDataPath, //
				modelPath, //
				];

			loadings = urls.concat();

			var loadData:Object = {urls: urls, singleComplete: singleComplete, singleCompleteParam: {}, allItemsLoaded: completeHandler};

			dispatcher.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, loadData));
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

			var gamedata:* = Load.loader.get(mapDataPath).content;
			GameData.NPCNameDic = gamedata.NPCNameDic;

			var model:* = Load.loader.get(modelPath).content;
			GameData.modelDic = model.modelDic;
			GameData.modelInfoDic = model.modelInfoDic;

			PreLoad.isPreloadCompleted = true;
			dispatcher.dispatchEvent(new GameEvent(GameEvent.PRE_LOAD_COMPLETED));
		}
	}
}
