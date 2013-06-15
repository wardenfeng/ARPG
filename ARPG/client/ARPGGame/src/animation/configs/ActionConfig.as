package animation.configs
{
	import animation.AnimationAction;

	/**
	 *
	 * @author warden feng 2013-6-8
	 */
	public class ActionConfig
	{
		private static var _config:Array;

		public function ActionConfig()
		{
		}

		public static function get config():Array
		{
			if (_config == null)
			{
				_config = [];
				setConfig(_config, ModelType.PLAYER_MODEL, ActionType.STAND, ["25|26|27|28|29|30", "1|2|3|4|5|6", "13|14|15|16|17|18", "19|20|21|22|23|24", "7|8|9|10|11|12"]);
				setConfig(_config, ModelType.PLAYER_MODEL, ActionType.ATTACK, ["55|56|57|58|58|59|60", "31|32|33|34|34|35|36", "43|44|45|46|46|47|48", "49|50|51|52|52|53|54", "37|38|39|40|40|41|42"]);
				setConfig(_config, ModelType.PLAYER_MODEL, ActionType.RUN, ["85|86|87|88|89|90", "61|62|63|64|65|66", "73|74|75|76|77|78", "79|80|81|82|83|84", "67|68|69|70|71|72"]);
				setConfig(_config, ModelType.PLAYER_MODEL, ActionType.WALK, ["115|116|117|118|119|120", "91|92|93|94|95|96", "103|104|105|106|107|108", "109|110|111|112|113|114", "97|98|99|100|101|102"]);
				setConfig(_config, ModelType.PLAYER_MODEL, ActionType.FELLDOWN, ["134|135|136|137", "126|127|128|129", "130|131|132|133", "130|131|132|133", "130|131|132|133"]);
				setConfig(_config, ModelType.PLAYER_MODEL, ActionType.CASTSKILL, ["162|163|164|165|166|166|166|166|166|167|162|162|162", "138|139|140|141|142|142|142|142|142|143|138|138|138", "150|151|152|153|154|154|154|154|154|155|150|150|150", "156|157|158|159|160|160|160|160|160|161|156|156|156", "144|145|146|147|148|148|148|148|148|149|144|144|144"]);
				setConfig(_config, ModelType.PLAYER_MODEL, ActionType.BEATTACKED, ["125|125", "121|121", "123|123", "124|124", "122|122"]);
			}
			return _config;
		}

		private static function setConfig(config:Array, modelType:int, act:int, actFrames:Array):void
		{
			var modelConfig:Array = config[modelType];
			if (modelConfig == null)
			{
				config[modelType] = modelConfig = [];
			}
			var actionConfig:Array = modelConfig[act];
			if (actionConfig == null)
			{
				modelConfig[act] = actionConfig = [];
			}

			actionConfig[Direction.DIR_UP] = getAnimationAction(actFrames[0], false);
			actionConfig[Direction.DIR_DOWN] = getAnimationAction(actFrames[1], false);
			actionConfig[Direction.DIR_RIGHT] = getAnimationAction(actFrames[2], false);
			actionConfig[Direction.DIR_LEFT] = getAnimationAction(actFrames[2], true);
			actionConfig[Direction.DIR_UP_RIGHT] = getAnimationAction(actFrames[3], false);
			actionConfig[Direction.DIR_UP_LEFT] = getAnimationAction(actFrames[3], true);
			actionConfig[Direction.DIR_DOWN_RIGHT] = getAnimationAction(actFrames[4], false);
			actionConfig[Direction.DIR_DOWN_LEFT] = getAnimationAction(actFrames[4], true);
		}

		private static function getAnimationAction(actFrame:String, turned:Boolean):AnimationAction
		{
			var frames:Array = actFrame.split("|");
			return new AnimationAction(frames, turned);
		}

		public static function getAction(modelType:int, action:int, direction:int):AnimationAction
		{
			return config[modelType][action][direction];
		}
	}
}
