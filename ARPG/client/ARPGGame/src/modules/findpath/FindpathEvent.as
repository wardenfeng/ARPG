package modules.findpath
{
	import flash.events.Event;


	/**
	 *
	 * @author 风之守望者 2012-7-3
	 */
	public class FindpathEvent extends Event
	{
		public static const FIND_PATH : String = "findPath";

		/**
		 * 起点X
		 */
		public var startX : int;

		/**
		 * 起点Y
		 */
		public var startY : int;

		/**
		 * 终点X
		 */
		public var endX : int;

		/**
		 * 终点Y
		 */
		public var endY : int;

		/**
		 * 寻找路径结果
		 */
		public var path : Array;

		/**
		 * 寻找路径事件
		 * @param startX 起点X
		 * @param startY 起点Y
		 * @param endX 终点X
		 * @param endY 终点Y
		 *
		 */
		public function FindpathEvent(type : String, startX : int, startY : int, endX : int, endY : int)
		{
			super(type);
			this.startX = startX;
			this.startY = startY;
			this.endX = endX;
			this.endY = endY;
		}
	}
}
