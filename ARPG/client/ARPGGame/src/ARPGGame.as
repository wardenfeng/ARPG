package
{
	import com.feng.FUI;
	import com.junkbyte.console.Cc;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import animation.animationtypes.MonsterAnimation;
	
	import communication.ServerAddress;
	import communication.arpg.ArpgSocketManager;
	
	import modules.GameDispatcher;
	import modules.chat.Chat;
	import modules.findpath.FindpathController;
	import modules.gamescene.GameScene;
	import modules.load.Load;
	import modules.load.LoadEvent;
	import modules.login.Login;
	import modules.login.LoginEvent;
	import modules.moveaction.MoveActionController;
	import modules.preload.PreLoad;
	import modules.prompt.Prompt;
	import modules.scenemap.Scenemap;
	import modules.shortcuts.ShortcutsController;

	/**
	 *
	 * @author warden_feng 2013-5-28
	 */
	[SWF(width = "1000", height = "580", frameRate = "30", backgroundColor = "0x000000")]
	public class ARPGGame extends Game
	{
		private var dispatcher:GameDispatcher = GameDispatcher.instance;

		public function ARPGGame()
		{
			super();
		}

		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);

			MyCC.initFlashConsole(this);
			GlobalData.logFunc = Cc.log;
			//GlobalData.logFunc = trace;

			FUI.init(stage);

			logger("客户端版本：" + GlobalData.VERSION);

			initMoudles();

			loadConfig();

			dispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_SHOW));

			var npc:MonsterAnimation = new MonsterAnimation("1001");
			npc.floorPoint = new Point(200, 200);
			addChild(npc);

			addEventListener(Event.ENTER_FRAME, function(event:Event):void
			{
				npc.animationController.enterFrame();
			});
		}

		private function loadConfig():void
		{
			dispatcher.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, {urls: [GlobalData.configPath], singleComplete: singleComplete, singleCompleteParam: {}}));
		}

		private function singleComplete(param:Object):void
		{
			if (GlobalData.configPath == param.url)
			{
				var config:XML = Load.loader.getXML(GlobalData.configPath);

				config.ignoreWhitespace = true;

				//初始化登陆服务器列表
				var server:ServerAddress;
				for each (var j:* in config.server)
				{
					server = new ServerAddress();
					server.host = j.host;
					server.port = j.port;
					server.policy = j.policy;
					GlobalData.loginServerArray.push(server);
				}
			}
		}

		/**
		 * 初始化模块
		 **/
		private function initMoudles():void
		{
			Load.init();

			Login.init();

			PreLoad.init();

			ArpgSocketManager.init();

			GameScene.init();

			//开启寻路模块
			FindpathController.start();

			//注册快捷键
			ShortcutsController.start();

			//开启移动模块
			MoveActionController.start();

			Scenemap.init();

			Prompt.init();
			
			Chat.init();
		}

	}
}
