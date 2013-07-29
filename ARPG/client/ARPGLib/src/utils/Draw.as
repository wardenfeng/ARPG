package utils
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	/**
	 *
	 * @author 风之守望者 2012-6-17
	 */
	public class Draw
	{
		/**
		 * 切图
		 * @param bitmapData    源图
		 * @param x          	切图起点X
		 * @param y          	切图起点Y
		 * @frameWidth		 	切图后宽
		 * @frameHeight			切图后高
		 **/
		public static function Cut(bitmapData : BitmapData, x : int, y : int, width : Number, height : Number) : BitmapData
		{
			var frame : BitmapData = new BitmapData(width, height, true, 0x00000000);
			var matrix : Matrix = new Matrix();
			matrix.tx = x;
			matrix.ty = y;
			frame.draw(bitmapData, matrix);
			return frame;
		}

		/** 图片水平翻转 */
		public static function HorizontalTurn(bitmapData : BitmapData) : BitmapData
		{
			var frame : BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00000000);
			frame.draw(bitmapData, new Matrix(-1, 0, 0, 1, frame.width, 0));
			return frame;
		}

		/** 图片垂直翻转 */
		public static function VerticalTurn(bitmapData : BitmapData) : BitmapData
		{
			var frame : BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00000000);
			frame.draw(bitmapData, new Matrix(1, 0, 0, -1, 0, frame.height));
			return frame;
		}
	}
}
