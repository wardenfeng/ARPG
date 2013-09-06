package modules.chat
{
	/**
	 * 
	 * @author warden_feng 2013-9-6
	 */
	public class Chat
	{
		public static const viewPath:String = GlobalData.rootPath + "resources/view/chatUI.swf";
		
		public static var isInit:Boolean = false;
		
		public static var isShow:Boolean = false;
		
		private static var chatViewManager:ChatViewManager;
		
		public static function init():void
		{
			chatViewManager || (chatViewManager = new ChatViewManager());
			
		}
	}
}