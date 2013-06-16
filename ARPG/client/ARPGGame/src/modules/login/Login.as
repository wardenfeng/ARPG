package modules.login
{
	public class Login
	{
		public static const viewPath:String = GlobalData.rootPath + "resources/view/loginUI.swf";

		public static var isInit:Boolean = false;

		public static var isShow:Boolean = false;
		
		public static var logined:Boolean = false;

		public static var logining:Boolean = false;
		
		private static var loginViewManager:LoginUIManager;

		public static function init():void
		{
			loginViewManager || (loginViewManager = new LoginUIManager());

		}
	}
}
