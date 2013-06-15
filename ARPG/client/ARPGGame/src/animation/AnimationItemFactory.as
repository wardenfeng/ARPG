package animation
{
	import flash.utils.Dictionary;
	
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import modules.GameDispatcher;
	import modules.load.LoadEvent;

	/**
	 *
	 * @author warden feng 2013-6-7
	 */
	public class AnimationItemFactory
	{
		private static var animationItemDic:Dictionary = new Dictionary();

		public function AnimationItemFactory()
		{
		}

		public static function getWeaponAnimationItem(weaponName:String):AnimationItem
		{
			var url:String = GlobalData.getPlayerWeaponPath(weaponName);
			var animationItem:AnimationItem = animationItemDic[url];
			if (animationItem == null)
			{
				animationItem = new AnimationItem(url);
				animationItemDic[url] = animationItem;

				var loadData:Object = {urls: [url], singleComplete: singleComplete, singleCompleteParam: {id: url}};

				GameDispatcher.instance.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, loadData));
			}
			return animationItem;
		}
		
		public static function getClothingAnimationItem(clothingName:String):AnimationItem
		{
			var url:String = GlobalData.getPlayerClothingPath(clothingName);
			var animationItem:AnimationItem = animationItemDic[url];
			if (animationItem == null)
			{
				animationItem = new AnimationItem(url);
				animationItemDic[url] = animationItem;

				var loadData:Object = {urls: [url], singleComplete: singleComplete, singleCompleteParam: {id: url}};

				GameDispatcher.instance.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, loadData));
			}
			return animationItem;
		}
		
		public static function getAnimationItem(url:String):AnimationItem
		{
			var animationItem:AnimationItem = animationItemDic[url];
			if (animationItem == null)
			{
				animationItem = new AnimationItem(url);
				animationItemDic[url] = animationItem;

				var loadData:Object = {urls: [url], singleComplete: singleComplete, singleCompleteParam: {id: url}};

				GameDispatcher.instance.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, loadData));
			}
			return animationItem;
		}

		public static function singleComplete(param:Object):void
		{
			var loadingItem:LoadingItem = param.loadingItem;
			var imageItem:ImageItem = loadingItem as ImageItem;

			var geometry:Array = imageItem.content["geometry"];
			var length:int = geometry.length / 2;
			var bitmapdatas:Array = [];

			for (var i:int = 1; i < length; i++)
			{
				bitmapdatas[i] = new (imageItem.getDefinitionByName("F" + i))();
			}
			var animationItem:AnimationItem = getAnimationItem(param.id);
			animationItem.init(geometry, bitmapdatas);

		}
	}
}
