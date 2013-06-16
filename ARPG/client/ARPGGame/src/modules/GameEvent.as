package modules
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		/** 预加载完成 */		
		public static const PRE_LOAD_COMPLETED:String = "preloadCompleted";
		
		public var data:*;

		public function GameEvent(type:String,data:* = null)
		{
			super(type);
			this.data = data;
		}
	}
}