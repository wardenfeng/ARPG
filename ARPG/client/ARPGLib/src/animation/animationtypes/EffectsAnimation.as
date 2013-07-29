package animation.animationtypes
{
	import animation.AnimationItemFactory;

	/**
	 * 特效动画
	 * @author warden feng 2013-6-14
	 */
	public class EffectsAnimation extends LoopAnimation
	{
		protected var _effectsName:String;

		public var skillIndex:int;
		
		public function EffectsAnimation(effectsName:String)
		{
			this.effectsName = effectsName;
			init();
		}

		public function get effectsName():String
		{
			return _effectsName;
		}

		public function set effectsName(value:String):void
		{
			if (_effectsName != value)
			{
				var url:String = GlobalData.geteffectPath(value);

				animationItem = AnimationItemFactory.getAnimationItem(url);
			}
			_effectsName = value;
		}
	}
}
