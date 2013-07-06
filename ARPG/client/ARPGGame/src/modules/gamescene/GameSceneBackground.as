package modules.gamescene
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import modules.GameDispatcher;
	import modules.load.LoadEvent;

	/**
	 *
	 * @author 风之守望者 2012-6-17
	 */
	public class GameSceneBackground extends Bitmap
	{
		private var _mapId:int;

		private var _startX:int;

		private var _startY:int;

		private var _endX:int;

		private var _endY:int;

		private var needUpdate:Boolean = true;

		public function GameSceneBackground()
		{
			bitmapData = new BitmapData(1500, 900, true, 0x0);
		}

		public function showMap(mapId:int, showArea:Rectangle):void
		{
			this.mapId = mapId;
			startX = showArea.x / GlobalData.MapTileWidth;
			startY = showArea.y / GlobalData.MapTileHeight;
			endX = Math.ceil(showArea.right / GlobalData.MapTileWidth);
			endY = Math.ceil(showArea.bottom / GlobalData.MapTileHeight);

			x = startX * GlobalData.MapTileWidth;
			y = startY * GlobalData.MapTileHeight;

			updateBitmapData();
		}

		private function updateBitmapData():void
		{
			if (!needUpdate)
				return;
			setBitmapData((endX - startX) * GlobalData.MapTileWidth, (endY - startY) * GlobalData.MapTileHeight);
			for (var i:int = startX; i < endX; i++)
			{
				for (var j:int = startY; j < endY; j++)
				{
					if(i >= 0 && j >=0)
					{
						var url:String = GlobalData.getMapPath(mapId, "" + i + "_" + j + ".jpg");
						var loadData:Object = {urls: [url], singleComplete: singleComplete, singleCompleteParam: {id: url, mapId: mapId, i: i, j: j, startX: startX, startY: startY}};
	
						GameDispatcher.instance.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, loadData));
					}
				}
			}
			needUpdate = false;
		}

		private function singleComplete(param:Object):void
		{
			var loadingItem:LoadingItem = param.loadingItem;
			var bitmap:Bitmap = loadingItem.content;

			if (param.mapId == mapId && param.startX == startX && param.startY == startY)
			{
				var destPoint:Point = new Point((param.i - param.startX) * GlobalData.MapTileWidth, (param.j - param.startY) * GlobalData.MapTileHeight);
				bitmapData.copyPixels(bitmap.bitmapData, bitmap.bitmapData.rect, destPoint);
			}
		}

		private function setBitmapData(width:Number, height:Number):void
		{
			if (bitmapData.width != width || bitmapData.height != height)
			{
				bitmapData = new BitmapData(width, height, true, 0x0);
			}
		}

		private function get mapId():int
		{
			return _mapId;
		}

		private function set mapId(value:int):void
		{
			needUpdate = needUpdate || _mapId != value
			_mapId = value;
		}

		private function get startX():int
		{
			return _startX;
		}

		private function set startX(value:int):void
		{
			needUpdate = needUpdate || _startX != value
			_startX = value;
		}

		private function get startY():int
		{
			return _startY;
		}

		private function set startY(value:int):void
		{
			needUpdate = needUpdate || _startY != value
			_startY = value;
		}

		private function get endX():int
		{
			return _endX;
		}

		private function set endX(value:int):void
		{
			needUpdate = needUpdate || _endX != value
			_endX = value;
		}

		private function get endY():int
		{
			return _endY;
		}

		private function set endY(value:int):void
		{
			needUpdate = needUpdate || _endY != value
			_endY = value;
		}


	}
}
