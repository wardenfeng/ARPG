package modules.scenemap
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import animation.animal.Player;
	
	import modules.GameEvent;
	import modules.ViewManager;
	import modules.findpath.MapTileModel;
	import modules.gamescene.GameSceneConfig;
	import modules.load.Load;
	import modules.load.LoadEvent;
	import modules.moveaction.MoveActionEvent;
	
	import utils.PopupManager;

	/**
	 * 场景地图
	 * @author warden_feng 2012-6-25
	 */
	public class ScenemapUIManager extends ViewManager
	{
		private var loading:Boolean = false;

		private var isLoad:Boolean = false;

		private var loadingPaths:Array;

		/** 背景图片 */
		public var backmap:Bitmap;

		/** 路径层 */
		public var pathLayer:Shape;

		/** 玩家层 */
		public var playerLayer:Sprite;

		/** 玩家字典 */
		public var playerDic:Dictionary = new Dictionary();

		/** 场景地图与实际地图比例X */
		public var mapScaleX:Number = 0;

		/** 场景地图与实际地图比例Y */
		public var mapScaleY:Number = 0;

		/** 主角 */
		public function get hero():Player
		{
			return GlobalData.hero;
		}

		/** 场景层 */
		private function get sceneLayer():Sprite
		{
			return UIAllRefer.sceneLayer;
		}

		public function ScenemapUIManager()
		{
			dispatcher.addEventListener(ScenemapEvent.SCENEMAP_SHOW, onGameEvent);
			dispatcher.addEventListener(ScenemapEvent.SCENEMAP_CLOSE, onGameEvent);
			dispatcher.addEventListener(ScenemapEvent.SCENEMAP_SHOW_CLOSE, onGameEvent);
		}

		override protected function init():void
		{
			if (loading)
				return;

			if (!isLoad)
			{
				loading = true;
				dispatcher.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, {urls: [GlobalData.currentSmallMapPath], allItemsLoaded: function():void
				{
					loading = false;
					isLoad = true;
					init();
				}}));
				return;
			}

			mainUI = new MovieClip();
			mainUI.name = "scenemapUI";
			mainUI.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			mainUI.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			//初始化背景地图
			backmap = new Bitmap(Load.loader.getBitmapData(GlobalData.currentSmallMapPath));
			backmap.name = "scenemap";
			mainUI.addChild(backmap);
			//计算缩放比例
			mapScaleX = backmap.width / GameSceneConfig.mapWidth;
			mapScaleY = backmap.height / GameSceneConfig.mapHeight;

			//初始化路径层
			pathLayer = new Shape();
			pathLayer.name = "pathLayer";
			mainUI.addChild(pathLayer);

			//初始化玩家层
			playerLayer = new Sprite();
			playerLayer.name = "playerLayer";
			playerLayer.mouseChildren = false;
			playerLayer.mouseEnabled = false;
			mainUI.addChild(playerLayer);

			PopupManager.centerPopUp(mainUI);

			Scenemap.isInit = true;

			show();
		}

		protected function onGameEvent(event:GameEvent):void
		{
			switch (event.type)
			{
				case ScenemapEvent.SCENEMAP_SHOW:
					show();
					break;
				case ScenemapEvent.SCENEMAP_CLOSE:
					close();
					break;
				case ScenemapEvent.SCENEMAP_SHOW_CLOSE:
					Scenemap.isShow ? close() : show();
					break;
			}
		}

		override protected function show():void
		{
			if (!Scenemap.isInit)
			{
				init();
				return;
			}

			updateView();

			Scenemap.isShow = true;

			PopupManager.addContentUI(mainUI,true);

			PopupManager.centerPopUp(mainUI);
		}

		override protected function updateView():void
		{
			updatePosition();
			drawPath(null, 0);
		}

		override protected function close():void
		{
			if (mainUI == null)
				return;
			
			PopupManager.removePopUp(mainUI);

			Scenemap.isShow = false;
		}

		override protected function onAddToStage(event:Event):void
		{
			mainUI.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			mainUI.addEventListener(MouseEvent.CLICK, onClick);

			dispatcher.addEventListener(MoveActionEvent.HERO_STEP_COMPLETED, onHeroStepCompleted);
		}

		override protected function onRemovedFromStage(event:Event):void
		{
			mainUI.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			mainUI.removeEventListener(MouseEvent.CLICK, onClick);
			dispatcher.removeEventListener(MoveActionEvent.HERO_STEP_COMPLETED, onHeroStepCompleted);
		}

		public function onEnterFrame(event:Event):void
		{
			updatePosition();
		}

		private function updatePosition():void
		{
			//添加主角
			if (playerLayer && hero != null && playerDic[0] == null)
			{
				var shape:Shape = new Shape();
				shape.name = "heroPoint";
				shape.graphics.beginFill(0xff0000);
				shape.graphics.drawCircle(0, 0, 3);
				shape.graphics.endFill();
				playerLayer.addChild(shape);
				playerDic[0] = shape;
			}
			//调整主角位置
			if (playerDic[0])
			{
				playerDic[0].x = mapScaleX * hero.x;
				playerDic[0].y = mapScaleY * hero.y;
			}
		}

		/**
		 * 点击地图
		 */
		private function onClick(event:MouseEvent):void
		{
			sceneLayer.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, event.localX / mapScaleX, event.localY / mapScaleY));
		}

		private function onHeroStepCompleted(event:MoveActionEvent):void
		{
			var path:Array = event.data.findPathArr;
			var currentStep:int = event.data.currentStep;
			drawPath(path, currentStep);
		}

		/**
		 * 绘制路径
		 */
		private function drawPath(path:Array, currentStep:int):void
		{
			pathLayer.graphics.clear();
			if (path == null)
				return;
			pathLayer.graphics.beginFill(0x00ff00);
			for (var i:int = currentStep + 1; i < path.length; i++)
			{
				var realPoint:Point = MapTileModel.realCoordinate(path[i][0], path[i][1]);
				pathLayer.graphics.drawCircle(realPoint.x * mapScaleX, realPoint.y * mapScaleY, 1);
			}
			pathLayer.graphics.endFill();
		}
	}
}
