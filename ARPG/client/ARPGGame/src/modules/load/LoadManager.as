package modules.load
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import modules.ModulesManager;

	public class LoadManager extends ModulesManager
	{
		public var loader:BulkLoader;

		/** 完成一个资源后执行的函数字典 */
		private var urlFuncsDic:Dictionary = new Dictionary();

		/** 完成一组资源后执行的函数字典 */
		private var urlsFuncsDic:Dictionary = new Dictionary();

		public function LoadManager()
		{
			initLoader();

			addListeners();
		}

		private function initLoader():void
		{
			// creates a BulkLoader instance with a name of "main-site", that can be used to retrieve items without having a reference to this instance
			loader = new BulkLoader("main-site");
			// set level to verbose, for debugging only
			loader.logLevel = BulkLoader.LOG_ERRORS;

			// dispatched when ALL the items have been loaded:
			loader.addEventListener(BulkLoader.COMPLETE, onAllItemsLoaded);

			// dispatched when any item has progress:
			loader.addEventListener(BulkLoader.PROGRESS, onAllItemsProgress);
		}

		private function addListeners():void
		{
			dispatcher.addEventListener(LoadEvent.LOAD_RESOURCE, onLoadResource);
		}

		private function onLoadResource(event:LoadEvent):void
		{
			var urls:Array = event.data.urls;
			var singleComplete:Function = event.data.singleComplete;
			var singleCompleteParam:Object = event.data.singleCompleteParam;
			var allItemsLoaded:Function = event.data.allItemsLoaded;
			var allItemsLoadedParam:Object = event.data.allItemsLoadedParam;


			//添加资源组加载完成回调函数
			var urlsFuncs:Array = urlsFuncsDic[urls];
			if (urlsFuncs == null)
			{
				urlsFuncs = [];
				urlsFuncsDic[urls] = urlsFuncs;
			}
			urlsFuncs.push({func: allItemsLoaded, param: allItemsLoadedParam});

			for each (var url:String in urls)
			{
				//添加单个资源加载完成回调函数
				var urlFuncs:Array = urlFuncsDic[url];
				if (urlFuncs == null)
				{
					urlFuncs = [];
					urlFuncsDic[url] = urlFuncs;
				}
				if (urlFuncs.indexOf(urlFuncs) == -1)
				{
					urlFuncs.push({func: singleComplete, param: singleCompleteParam});
				}

				//加载资源
				if (loader.hasItem(url))
				{
					var loadingItem:LoadingItem = loader.get(url);
					if (loadingItem.isLoaded)
					{
						singleLoaded(loadingItem);
					}
				}
				else
				{
					loader.add(url);
					loader.get(url).addEventListener(BulkLoader.COMPLETE, onSingleComplete);
				}
			}
			if (!loader.isRunning)
				loader.start();
		}

		private function onSingleComplete(event:Event):void
		{
			var loadingItem:LoadingItem = event.target as LoadingItem;

			loader.get(loadingItem.url.url).removeEventListener(BulkLoader.COMPLETE, onSingleComplete);

			singleLoaded(loadingItem);
		}

		private function singleLoaded(loadingItem:LoadingItem):void
		{
			dispatcher.dispatchEvent(new LoadEvent(LoadEvent.LOAD_SINGLE_COMPLETE, loadingItem));

			var loadedUrl:String = loadingItem.url.url;

			var func:Function;
			var param:Object;

			//执行单个资源加载完成回调函数
			var urlFuncs:Array = urlFuncsDic[loadedUrl];
			for each (var singleCompleteObj:Object in urlFuncs)
			{
				func = singleCompleteObj.func;
				param = singleCompleteObj.param;
				if (func)
				{
					if (param != null)
					{
						param.url = loadedUrl;
						param.loadingItem = loadingItem;
						func(param);
					}
					else
					{
						func();
					}
				}
			}
			urlFuncsDic[loadedUrl] = null;
			delete urlFuncsDic[loadedUrl];

			//检查资源组加载完成，并执行回调函数
			for (var urls:Array in urlsFuncsDic)
			{
				var index:int = urls.indexOf(loadedUrl);
				if (index != -1)
				{
					urls.splice(index, 1);
				}
				if (urls.length == 0)
				{
					var urlsFuncs:Array = urlsFuncsDic[urls];
					for each (var allItemsLoadedObj:Object in urlsFuncs)
					{
						func = allItemsLoadedObj.func;
						param = allItemsLoadedObj.param;
						if (func)
						{
							if (param != null)
							{
								func(param);
							}
							else
							{
								func();
							}
						}
					}
					urlsFuncsDic[urls] = null;
					delete urlsFuncsDic[urls];
				}
			}
		}

		public function onAllItemsLoaded(evt:Event):void
		{
			logger("every thing is loaded!");
		}

		// this evt is a "super" progress event, it has all the information you need to 
		// display progress by many criterias (bytes, items loaded, weight)
		public function onAllItemsProgress(evt:BulkProgressEvent):void
		{
//			logger(evt.loadingStatus());
		}

	}
}
