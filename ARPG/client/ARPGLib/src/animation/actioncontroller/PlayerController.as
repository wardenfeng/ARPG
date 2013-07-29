package animation.actioncontroller
{
	import animation.AnimationEvent;
	import animation.configs.ActionConfig;
	import animation.configs.ActionType;
	import animation.configs.Direction;
	import animation.configs.ModelType;

	[Event(name = "directionChange", type = "animation.AnimationEvent")]
	[Event(name = "actionChange", type = "animation.AnimationEvent")]
	/**
	 * 玩家动作控制
	 * @author warden_feng 2013-6-7
	 */
	public class PlayerController extends LoopController
	{
		private var _direction:int = Direction.DIR_DOWN;

		private var _action:int = ActionType.STAND;
		
		private const modelType:int = ModelType.PLAYER;

		/** 动作与速度 */
		private var _actionSpeed:Array;

		public function PlayerController()
		{
			super();
			//初始化方向与动作
			direction = Direction.DIR_DOWN;
			action = ActionType.STAND;
		}

		override public function set totalFrame(value:int):void
		{
			_totalFrame = value;
		}

		private function get actionSpeed():Array
		{
			if (_actionSpeed == null)
			{
				//定义动作速度大小
				_actionSpeed = [];
//				_actionSpeed[ActionType.STAND] = 0;
				_actionSpeed[ActionType.WALK] = 2;
				_actionSpeed[ActionType.RUN] = 4;
//				_actionSpeed[ActionType.ATTACK] = 0;
//				_actionSpeed[ActionType.FELLDOWN] = 0;
//				_actionSpeed[ActionType.BEATTACKED] = 0;
//				_actionSpeed[ActionType.CASTSKILL] = 0;
			}
			return _actionSpeed;
		}

		public function get direction():int
		{
			return _direction;
		}

		public function set direction(value:int):void
		{
			if (value == Direction.DIR_NULL)
			{
				action = ActionType.STAND;
			}
			else
			{
				_direction = value;
				dispatchEvent(new AnimationEvent(AnimationEvent.DIRECTION_CHANGE));
			}
			animationAction = ActionConfig.getAction(modelType, _action, _direction);
		}

		public function get action():int
		{
			return _action;
		}

		public function set action(value:int):void
		{
			_action = value;
			dispatchEvent(new AnimationEvent(AnimationEvent.ACTION_CHANGE));
			animationAction = ActionConfig.getAction(modelType, _action, _direction);
		}

		public function get speed():int
		{
			return actionSpeed[_action];
		}
	}
}
