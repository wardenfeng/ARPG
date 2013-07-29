package communication.arpg
{
	import com.netease.protobuf.Message;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import communication.ProtoFactory;
	import communication.SocketConnected;
	
	import modules.GameDispatcher;
	import modules.login.LoginEvent;

	

	public class ArpgSocket extends SocketConnected
	{
		private static var _instance:ArpgSocket;

		public static var dispatcher:GameDispatcher = GameDispatcher.instance;
		
		public static function init():void
		{
			if (_instance == null)
			{
				_instance=new ArpgSocket(GlobalData.loginServerArray);
			}
		}


		public static function get instance():ArpgSocket
		{
			return _instance;
		}

		private var msgProcesser:ARPGMsgProcessor=ARPGMsgProcessor.getInstance();

		public function ArpgSocket(serverArray:Array)
		{
			super(serverArray);
		}

		private var _authRequest:Message=null;

		public function set authRequest(authRequest:Message):void
		{
			_authRequest=authRequest;
		}

		override protected function connectionComplete():void
		{
			logger("Login Socket connection Complete..");
			if (_authRequest != null)
			{
				send(ARPGProto.ASID_LOGIN_REQ, _authRequest);
				_authRequest=null;
			}
		}

		override protected function connectFailed():void
		{
			super.connectFailed();

			dispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_FAIL));

			logger("登录服务器连接失败");
		}

		override protected function dispatchMessage(messageId:uint, data:ByteArray):void
		{
			super.dispatchMessage(messageId, data)
			ProtoFactory.getSlotProto().Decode(messageId, data, msgProcesser);
		}
		
		override protected function closeHandler(event:Event):void
		{
			super.closeHandler(event);
			dispatcher.dispatchEvent(new ArpgMsgEvent(ArpgMsgEvent.LOST_CONNECTION));
		}
	}
}
