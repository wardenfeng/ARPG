package animation.configs
{
	import animation.AnimationAction;

	/**
	 * 动作配置
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
				//配置人物动作
				setConfig(_config, ModelType.PLAYER, ActionType.STAND, ["25|26|27|28|29|30", "1|2|3|4|5|6", "13|14|15|16|17|18", "19|20|21|22|23|24", "7|8|9|10|11|12"], false);
				setConfig(_config, ModelType.PLAYER, ActionType.ATTACK, ["55|56|57|58|58|59|60", "31|32|33|34|34|35|36", "43|44|45|46|46|47|48", "49|50|51|52|52|53|54", "37|38|39|40|40|41|42"], false);
				setConfig(_config, ModelType.PLAYER, ActionType.RUN, ["85|86|87|88|89|90", "61|62|63|64|65|66", "73|74|75|76|77|78", "79|80|81|82|83|84", "67|68|69|70|71|72"], false);
				setConfig(_config, ModelType.PLAYER, ActionType.WALK, ["115|116|117|118|119|120", "91|92|93|94|95|96", "103|104|105|106|107|108", "109|110|111|112|113|114", "97|98|99|100|101|102"], false);
				setConfig(_config, ModelType.PLAYER, ActionType.FELLDOWN, ["134|135|136|137", "126|127|128|129", "130|131|132|133", "130|131|132|133", "130|131|132|133"], false);
				setConfig(_config, ModelType.PLAYER, ActionType.CASTSKILL, ["162|163|164|165|166|166|166|166|166|167|162|162|162", "138|139|140|141|142|142|142|142|142|143|138|138|138", "150|151|152|153|154|154|154|154|154|155|150|150|150", "156|157|158|159|160|160|160|160|160|161|156|156|156", "144|145|146|147|148|148|148|148|148|149|144|144|144"], false);
				setConfig(_config, ModelType.PLAYER, ActionType.BEATTACKED, ["125|125", "121|121", "123|123", "124|124", "122|122"], false);
				//配置怪物动作
				setConfig(_config, ModelType.MONSTER, ActionType.STAND, ["17|18|19|20", "1|2|3|4", "9|10|11|12", "13|14|15|16", "5|6|7|8"], true);
				setConfig(_config, ModelType.MONSTER, ActionType.ATTACK, ["41|42|43|44|45", "21|22|23|24|25", "31|32|33|34|35", "36|37|38|39|40", "26|27|28|29|30"], true);
				setConfig(_config, ModelType.MONSTER, ActionType.CASTSKILL, ["41|42|43|44|45", "21|22|23|24|25", "31|32|33|34|35", "36|37|38|39|40", "26|27|28|29|30"], true);
				setConfig(_config, ModelType.MONSTER, ActionType.RUN, ["70|71|72|73|74|75", "46|47|48|49|50|51", "58|59|60|61|62|63", "64|65|66|67|68|69", "52|53|54|55|56|57"], true);
				setConfig(_config, ModelType.MONSTER, ActionType.FELLDOWN, ["83", "81", "82", "82", "82"], true);
				setConfig(_config, ModelType.MONSTER, ActionType.BEATTACKED, ["80|80", "76|76", "78|78", "79|79", "77|77"], true);

			}
			return _config;
		}

		private static function setConfig(config:Array, modelType:int, act:int, actFrames:Array, turned:Boolean):void
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
