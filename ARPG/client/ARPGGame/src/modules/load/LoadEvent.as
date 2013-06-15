package modules.load
{
	import flash.events.Event;

	/**
	 * 登陆事件
	 * @author xumin.xu
	 *
	 */
	public class LoadEvent extends Event
	{
		public static const LOAD_RESOURCE:String = "loadResource";

		public static const LOAD_SINGLE_COMPLETE:String = "loadSingleComplete";

		public var data:*;

		public function LoadEvent(type:String, data:* = null)
		{
			super(type);
			this.data = data;
		}

	}
}
