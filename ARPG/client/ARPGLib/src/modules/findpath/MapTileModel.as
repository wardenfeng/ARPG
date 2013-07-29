package modules.findpath
{
	import flash.geom.Point;

	import modules.gamescene.GameSceneConfig;

	/**
	 *
	 * @author 风之守望者 2012-6-17
	 */
	public class MapTileModel
	{
		public static const PATH_PASS:int = 0; // 路径中 0 为可以通过

		public static const PATH_BARRIER:int = 1; // 路径中 1 为障碍

		public static const PATH_TRANSPARENT:int = 2; //透明

		public var mapData:Array; // 地图数据

		/**
		 * 是否为障碍
		 * @param startX	始点X坐标
		 * @param startY	始点Y坐标
		 * @param endX	终点X坐标
		 * @param endY	终点Y坐标
		 * @return 0为通路 1为障碍 2 为半透明 3 为摆摊位
		 */
		public function IsBlock(startX : int, startY : int, endX : int, endY : int) : int
		{
			var mapWidth : int = this.mapData.length;
			var mapHeight : int = this.mapData[0].length;
			
			if (endX < 0 || endX >= mapWidth || endY < 0 || endY >= mapHeight)
			{
				return 1;
			}
			if (this.mapData[endX] != null && this.mapData[endX][endY] != null)
			{
				return this.mapData[endX][endY];
			}
			else
			{
				return 1;
			}
		}
		
		/**
		 * 真实坐标转格子坐标
		 * @param x 真实坐标x
		 * @param y 真实坐标y
		 * @return 格子坐标
		 */
		public static function girdCoordinate(x:Number, y:Number):Point
		{
			var newX:Number = Math.floor((x + GameSceneConfig.TILE_WIDTH / 2) / GameSceneConfig.TILE_WIDTH);
			var newY:Number = Math.floor((y + GameSceneConfig.TILE_HEIGHT / 2) / GameSceneConfig.TILE_HEIGHT);
			return new Point(newX, newY);
		}

		/**
		 * 格子坐标转真实坐标
		 * @param x 格子坐标x
		 * @param y 格子坐标y
		 * @return 真实坐标
		 */
		public static function realCoordinate(x:Number, y:Number):Point
		{
			var newX:Number = GameSceneConfig.TILE_WIDTH * x;
			var newY:Number = GameSceneConfig.TILE_HEIGHT * y;
			return new Point(newX, newY);
		}
	}
}
