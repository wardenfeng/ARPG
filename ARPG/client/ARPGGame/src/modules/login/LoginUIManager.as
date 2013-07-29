package modules.login
{
	import com.feng.components.FButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import communication.ServerAddress;
	
	import modules.GameEvent;
	import modules.ViewManager;
	import modules.load.Load;
	import modules.load.LoadEvent;
	
	import utils.PopupManager;

	public class LoginUIManager extends ViewManager
	{
		private var loading:Boolean = false;

		private var isLoad:Boolean = false;

		private var mainUI:MovieClip;

		public function LoginUIManager()
		{
			dispatcher.addEventListener(LoginEvent.LOGIN_SHOW, onGameEvent);
		}

		override protected function init():void
		{
			if (loading)
				return;

			if (!isLoad)
			{
				loading = true;
				dispatcher.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, {urls: [Login.viewPath], allItemsLoaded: function():void
				{
					loading = false;
					isLoad = true;
					init();
				}}));
				return;
			}

			mainUI = Load.getInstance("fla.ui.LoginUI");
			mainUI.name = "LoginUI";

			mainUI.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			mainUI.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			mainUI.infoTxt.text = "Please to login.";
			mainUI.usernameTxt.text = "test" + int(Math.random() * 999 + 1);

			Login.isInit = true;

			show();
		}

		override protected function show():void
		{
			if (!Login.isInit)
			{
				init();
				return;
			}

			updateView();

			Login.isShow = true;

			PopupManager.addContentUI(mainUI,true);
		}

		override protected function updateView():void
		{
			mainUI.usernameTxt.mouseEnabled = !Login.logining;
			mainUI.passwordTxt.mouseEnabled = !Login.logining;
			FButton.getInstance(mainUI.loginBtn).enabled = !Login.logining;
		}

		override protected function close():void
		{
			PopupManager.removePopUp(mainUI);

			Login.isShow = false;
		}

		override protected function onAddToStage(event:Event):void
		{
			dispatcher.addEventListener(LoginEvent.LOGIN_SUCCEED, onLoginSucceed);

			dispatcher.addEventListener(LoginEvent.LOGIN_FAIL, onLoginFail);

			mainUI.loginBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		override protected function onRemovedFromStage(event:Event):void
		{
			dispatcher.removeEventListener(LoginEvent.LOGIN_SUCCEED, onLoginSucceed);

			dispatcher.removeEventListener(LoginEvent.LOGIN_FAIL, onLoginFail);

			mainUI.loginBtn.removeEventListener(MouseEvent.CLICK, onClick);
		}

		/**
		 * 处理登陆成功
		 * @param event
		 */
		private function onLoginSucceed(event:LoginEvent):void
		{
			updateView();
			close();
		}

		/**
		 * 处理登陆失败
		 * @param event
		 */
		private function onLoginFail(event:LoginEvent):void
		{
			updateView();

			var data:Object = event.data;
			if (data && data.info)
			{
				mainUI.infoTxt.text = data.info;
			}
			else
			{
				mainUI.infoTxt.text = "登陆失败";
			}
		}

		protected function onGameEvent(event:GameEvent):void
		{
			switch (event.type)
			{
				case LoginEvent.LOGIN_SHOW:
					show();
					break;
			}
		}

		protected function onClick(event:MouseEvent):void
		{
			switch (event.currentTarget)
			{
				case mainUI.loginBtn:
					if (Login.logining)
					{
						return;
					}
					var userName:String = mainUI.usernameTxt.text;
					var password:String = mainUI.passwordTxt.text;
					if (userName == "")
					{
						mainUI.infoTxt.text = "user name can not be null.";
						return;
					}

					if (password == "")
					{
						mainUI.infoTxt.text = "password can not be null.";
						return;
					}
					Login.logining = true;
					mainUI.infoTxt.text = "login. please wait...";

					//修改登陆服务器的host
					var server:ServerAddress = GlobalData.loginServerArray[0];

					//登陆
					dispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGIN, {username: userName, password: password}));

					updateView();
					break;
			}
		}
	}
}
