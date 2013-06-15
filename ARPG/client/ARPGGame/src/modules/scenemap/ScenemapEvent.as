package modules.scenemap
{
	import modules.GameEvent;

	/**
	 * 场景地图事件
	 * @author 风之守望者 2012-7-2
	 */
	public class ScenemapEvent extends GameEvent
	{
		/**
		 *  显示场景地图界面
		 */
		public static const SCENEMAP_SHOW : String = "scenemapShow";

		/**
		 *  关闭场景地图界面
		 */
		public static const SCENEMAP_CLOSE : String = "scenemapClose";

		/**
		 *  显示或关闭场景地图界面(显示时关闭，关闭时显示)
		 */
		public static const SCENEMAP_SHOW_CLOSE : String = "scenemapShowClose";

		/**
		 * 登录事件
		 * @param type 事件类型
		 * @param data 附加数据
		 */
		public function ScenemapEvent(type : String, data : Object = null)
		{
			super(type,data);
		}
	}
}
