package animation.configs
{
	import flash.geom.Point;

	/**
	 * 方向
	 * @author warden feng 2013-6-3
	 */
	public class Direction
	{
		//定义方向
		public static const DIR_DOWN_LEFT:int = 1;

		public static const DIR_DOWN:int = 2;

		public static const DIR_DOWN_RIGHT:int = 3;

		public static const DIR_LEFT:int = 4;

		public static const DIR_NULL:int = 5;

		public static const DIR_RIGHT:int = 6;

		public static const DIR_UP_LEFT:int = 7;

		public static const DIR_UP:int = 8;

		public static const DIR_UP_RIGHT:int = 9;

		/** 值与方向 */
		public static const DIRECTION_VALUE:Array = //
			[[DIR_UP_LEFT, DIR_UP, DIR_UP_RIGHT], //
			[DIR_LEFT, DIR_NULL, DIR_RIGHT], //
			[DIR_DOWN_LEFT, DIR_DOWN, DIR_DOWN_RIGHT]];

		public static function getDirection(p:Point):int
		{
			var direction:int = DIR_RIGHT;

			if (p.x == 0 && p.y == 0)
				return DIR_NULL;
			var angle:Number = Math.asin(p.y / p.length);
			if (p.x > 0 && p.y < 0)
			{
				angle = angle + Math.PI * 2;
			}
			if (p.x <= 0)
			{
				angle = Math.PI - angle;
			}
			angle = angle + Math.PI / 8;

			if (angle > Math.PI * 2)
				angle = angle - Math.PI * 2;
			var index:int = angle / (Math.PI / 4);
			switch (index)
			{
				case 0:
					direction = DIR_RIGHT;
					break;
				case 1:
					direction = DIR_DOWN_RIGHT;
					break;
				case 2:
					direction = DIR_DOWN;
					break;
				case 3:
					direction = DIR_DOWN_LEFT;
					break;
				case 4:
					direction = DIR_LEFT;
					break;
				case 5:
					direction = DIR_UP_LEFT;
					break;
				case 6:
					direction = DIR_UP;
					break;
				case 7:
					direction = DIR_UP_RIGHT;
					break;
			}
			return direction;
		}
	}
}
