package modules.load
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	public class Load
	{
		private static var loadManager:LoadManager;

		public static function init():void
		{
			loadManager = new LoadManager();
		}

		public static function get loader():BulkLoader
		{
			return loadManager.loader;
		}

		public static function getDefinitionByName(className:String):Object
		{
			for each (var loadingItem:LoadingItem in loader.items)
			{
				var imageItem:ImageItem = loadingItem as ImageItem;
				if (imageItem && imageItem.content)
				{
					if (imageItem.getDefinitionByName(className))
						return imageItem.getDefinitionByName(className);
				}
			}
			return null;
		}

		public static function getInstance(className:String):*
		{
			var cls:Class = getDefinitionByName(className) as Class;
			if (cls)
				return new cls();
			return null;
		}
	}
}
