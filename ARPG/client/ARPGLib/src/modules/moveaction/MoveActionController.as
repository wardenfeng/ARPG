package modules.moveaction
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import animation.animal.Player;
	
	import modules.GameDispatcher;

	/**
	 * 处理动物的移动
	 * @author warden_feng 2012-7-3
	 */
	public class MoveActionController
	{
		/** A*寻得路径 */
		public static var findPathArr:Array;

		/** 当前步数 */
		public static var currentStep:int = 0;

		private function get dispatcher():GameDispatcher
		{
			return GameDispatcher.instance;
		}

		public function get hero():Player
		{
			return GlobalData.hero;
		}

		public function MoveActionController()
		{
			dispatcher.addEventListener(MoveActionEvent.HERO_START_MOVE, onHeroMove);
		}

		private function onHeroMove(event:MoveActionEvent):void
		{
			findPathArr = event.data as Array;
			currentStep = 0;
			animalMove();
			dispatcher.addEventListener("animal_move_over", onAnimalMoveOver);
		}

		/**
		 * 主角移动
		 */
		private function animalMove():void
		{
			//给主角设置目的地
			if (findPathArr && currentStep < findPathArr.length - 1)
			{
				currentStep++;

				var destination:Array = findPathArr[currentStep];

				//通知服务器行走
				dispatcher.dispatchEvent(new MoveActionEvent(MoveActionEvent.HERO_MOVE_REQ, {mapX: destination[0], mapY: destination[1]}));

				//
				hero.destination = new Point(destination[0], destination[1]);
				dispatcher.dispatchEvent(new MoveActionEvent(MoveActionEvent.HERO_STEP_COMPLETED, {findPathArr: findPathArr, currentStep: currentStep}));
			}
			else
			{
				findPathArr = null;
				currentStep = 0;
				dispatcher.dispatchEvent(new MoveActionEvent(MoveActionEvent.HERO_END_MOVE));
				trace("到达目的地");
			}
		}

		private function onAnimalMoveOver(event:Event):void
		{
			animalMove();
		}

		// ----------------------------------------
		//
		//		单例模式
		//
		// ----------------------------------------
		private static var _instance:MoveActionController;

		public static function start():MoveActionController
		{
			return instance;
		}

		public static function get instance():MoveActionController
		{
			if (_instance == null)
				_instance = new MoveActionController();
			return _instance;
		}
	}
}
