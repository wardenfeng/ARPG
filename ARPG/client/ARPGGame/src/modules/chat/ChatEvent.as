package modules.chat
{
	import modules.GameEvent;
	
	/**
	 * 
	 * @author warden_feng 2013-9-6
	 */
	public class ChatEvent extends GameEvent
	{
		/** 显示登陆界面 */
		public static const CHAT_SHOW:String = "CHAT_SHOW";
		
		/** 玩家说话 */
		public static var SPEAK:String = "speak";
		
		public function ChatEvent(type:String, data:* = null)
		{
			super(type, data);
		}
	}
}