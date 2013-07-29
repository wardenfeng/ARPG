package modules.gamescene
{
	import flash.events.Event;

	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import modules.GameDispatcher;
	import modules.load.Load;
	import modules.load.LoadEvent;

	/**
	 *
	 * @author 风之守望者 2012-6-17
	 */
	public class GameSceneConfig
	{
		private var mapId:int;

		private var mapConfigUrl:String = "";

		/** 地图名称 */
		public static var mapName:String;

		/** 地图格子类型  1、矩形 */
		public static var tileType:int;

		/** 地图宽度 */
		public static var mapWidth:int;

		/** 地图高度 */
		public static var mapHeight:int;

		/** 格子宽度 */
		public static var TILE_WIDTH:int = 50;

		/** 格子高度 */
		public static var TILE_HEIGHT:int = 25;

		/** 列数 */
		public static var Row:int;

		/** 行数 */
		public static var Col:int;

		/** 地图掩码数据 */
		public static var mapData:Array;

		public function GameSceneConfig(mapId:int)
		{
			this.mapId = mapId;

			mapConfigUrl = GlobalData.getMapPath(mapId, "config.swf");

			dispatcher.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, {urls: [mapConfigUrl], allItemsLoaded: completeHandler}));
		}

		private function get dispatcher():GameDispatcher
		{
			return GameDispatcher.instance;
		}

		private function completeHandler():void
		{
			var loadingItem:LoadingItem = Load.loader.get(mapConfigUrl);
			var imageItem:ImageItem = loadingItem as ImageItem;

			var configContent:* = imageItem.content;

			GameSceneConfig.mapName = configContent["mapName"];
			GameSceneConfig.tileType = 1;
			GameSceneConfig.mapWidth = configContent["mapWidth"];
			GameSceneConfig.mapHeight = configContent["mapHeight"];
			GameSceneConfig.TILE_WIDTH = configContent["TILE_WIDTH"];
			GameSceneConfig.TILE_HEIGHT = configContent["TILE_HEIGHT"];
			GameSceneConfig.Row = configContent["Row"];
			GameSceneConfig.Col = configContent["Col"];
			GameSceneConfig.mapData = configContent["mapData"];

			GameDispatcher.instance.dispatchEvent(new GameSceneEvent(GameSceneEvent.SCENE_CONFIG_COMPLETED));
		}
	}
}
