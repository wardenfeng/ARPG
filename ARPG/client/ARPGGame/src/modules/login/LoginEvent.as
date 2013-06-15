package modules.login
{
	import modules.GameEvent;

	public class LoginEvent extends GameEvent
	{
		/** 显示登陆界面 */
		public static const LOGIN_SHOW:String = "loginShow";

		/** 登陆 */
		public static const LOGIN:String = "login";
		
		/** 登陆成功 */
		public static const LOGIN_SUCCEED:String = "loginSucceed";
		
		/** 登陆失败 */
		public static const LOGIN_FAIL:String = "loginFail";
		
		public function LoginEvent(type:String, data:* = null)
		{
			super(type, data);
		}
	}
}
