package animation.animationtypes
{
	import animation.AnimationEvent;
	import animation.actioncontroller.PlayerController;
	import animation.configs.ActionType;

	/**
	 * 玩家动画
	 * @author warden feng 2013-6-7
	 */
	public class PlayerAnimation extends LoopAnimation
	{
		public function PlayerAnimation()
		{
			playerController = new PlayerController();
		}

		public function get playerController():PlayerController
		{
			return loopController as PlayerController;
		}

		public function set playerController(value:PlayerController):void
		{
			loopController = value;
		}

		override protected function onControllerLooped(event:AnimationEvent):void
		{
			super.onControllerLooped(event);
			switch (playerController.action)
			{
				case ActionType.CASTSKILL:
					playerController.action = ActionType.STAND;
					break;
			}
		}
	}
}
