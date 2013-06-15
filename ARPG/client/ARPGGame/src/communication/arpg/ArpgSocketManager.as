package communication.arpg
{
	import com.netease.protobuf.Message;

	import modules.GameDispatcher;
	import modules.login.LoginEvent;

	import protobuf.ASPKG_LOGIN_REQ;

	public class ArpgSocketManager
	{
		private static var instance:ArpgSocketManager;

		public static function init():void
		{
			logger("登录socket模块初始化");
			if (instance == null)
			{
				instance = new ArpgSocketManager();
			}
		}

		private var gobangSocket:ArpgSocket;

		private var dispatcher:GameDispatcher = GameDispatcher.instance;

		public function ArpgSocketManager()
		{
			addListeners();
		}

		private function addListeners():void
		{
			dispatcher.addEventListener(LoginEvent.LOGIN, onLogin);

			dispatcher.addEventListener(LoginEvent.LOGIN_SUCCEED, onLoginSucceed);
		}

		/**
		 * 初始化登录socket
		 */
		private function initLoginSocket():void
		{
			ArpgSocket.init();
			gobangSocket = ArpgSocket.instance;
		}

		/** 处理登录 */
		public function onLogin(event:LoginEvent):void
		{
			initLoginSocket();

			var userName:String = event.data.username;
			var password:String = event.data.password;

			var loginReq:ASPKG_LOGIN_REQ = new ASPKG_LOGIN_REQ();
			loginReq.account = userName;
			loginReq.password = password;

			doLogin(loginReq);
		}

		/** 登录 */
		private function doLogin(authRequest:Message):void
		{
			if (gobangSocket == null)
			{
				logger("try login but server info is null.");
				return;
			}
			if (gobangSocket.hasConnected())
			{
				gobangSocket.send(ARPGProto.ASID_LOGIN_REQ, authRequest);
			}
			else
			{
				gobangSocket.authRequest = authRequest;
				gobangSocket.connect();
			}
		}

		/**
		 * 处理登录成功
		 * @param event
		 */
		private function onLoginSucceed(event:LoginEvent):void
		{
			ArpgMsgSender.init(gobangSocket);
		}
	}
}
