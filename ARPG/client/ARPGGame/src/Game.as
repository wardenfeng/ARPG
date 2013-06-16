package
{
	import com.feng.FUI;
	import com.junkbyte.console.Cc;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import animation.actioncontroller.PlayerController;
	import animation.animationtypes.NPCAnimation;
	import animation.animationtypes.PlayerAnimation;
	import animation.animationtypes.WeaponAnimation;
	
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import communication.ServerAddress;
	import communication.arpg.ArpgSocketManager;
	
	import modules.GameDispatcher;
	import modules.findpath.FindpathController;
	import modules.gamescene.GameScene;
	import modules.load.Load;
	import modules.load.LoadEvent;
	import modules.login.Login;
	import modules.login.LoginEvent;
	import modules.moveaction.MoveActionController;
	import modules.preload.PreLoad;
	import modules.scenemap.Scenemap;
	import modules.shortcuts.ShortcutsController;

	/**
	 *
	 * @author 风之守望者 2013-5-28
	 */
	[SWF(width = "1000", height = "580", frameRate = "30", backgroundColor = "0x000000")]
	public class Game extends Sprite
	{
		private var dispatcher:GameDispatcher = GameDispatcher.instance;

		public function Game()
		{
			Security.allowDomain("*");

			var menu0:ContextMenuItem = new ContextMenuItem("Gobang\t" + GlobalData.VERSION, true, true, true);
			var viewContextMenu:ContextMenu = new ContextMenu();
			viewContextMenu.customItems = [menu0];
			contextMenu = viewContextMenu;

			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);

		}

		private function onAddToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);

			this.stage.tabChildren = false;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;


			MyCC.initFlashConsole(this);
			GlobalData.logFunc = Cc.log;
			//			GlobalData.logFunc = trace;

			UIAllRefer.stage = this.stage;

			FUI.init(stage);

			initLayers();

			logger("客户端版本：" + GlobalData.VERSION);

			initMoudles();

			loadConfig();

			dispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_SHOW));

			var npc:NPCAnimation = new NPCAnimation("19");
			npc.floorPoint = new Point(200,200);
			addChild(npc);
			
//			playerAnimation.playerController = new PlayerController();
			
			addEventListener(Event.ENTER_FRAME,function(event:Event):void
			{
				npc.animationController.enterFrame();
			});
		}

		private function initLayers():void
		{
			UIAllRefer.backLayer.name = "backLayer";
			this.stage.addChild(UIAllRefer.backLayer);
			UIAllRefer.sceneLayer.name = "sceneLayer";
			this.stage.addChild(UIAllRefer.sceneLayer);
			UIAllRefer.contentLayer.name = "contentLayer";
			this.stage.addChild(UIAllRefer.contentLayer);
			UIAllRefer.popLayer.name = "popLayer";
			this.stage.addChild(UIAllRefer.popLayer);
			UIAllRefer.infoLayer.name = "infoLayer";
			this.stage.addChild(UIAllRefer.infoLayer);
			UIAllRefer.tipLayer.name = "tipLayer";
			this.stage.addChild(UIAllRefer.tipLayer);
		}

		private function loadConfig():void
		{
			dispatcher.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, {urls: [GlobalData.configPath], allItemsLoaded: onLoadSingleComplete}));
		}

		private function onLoadSingleComplete():void
		{
			var loadingItem:LoadingItem = Load.loader.get(GlobalData.configPath);
			if (GlobalData.configPath == loadingItem.url.url)
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
		}

	}
}
