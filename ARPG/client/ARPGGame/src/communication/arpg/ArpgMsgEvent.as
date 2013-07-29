package communication.arpg
{
	import modules.GameEvent;

	/**
	 * 老虎机协议事件
	 * @author xumin.xu
	 */
	public class ArpgMsgEvent extends GameEvent
	{
		/** 失去连接 */		
		public static const LOST_CONNECTION:String = "lostConnection";
		
		public function ArpgMsgEvent(type:String, data:* = null)
		{
			super(type,data);
		}
	}
}
