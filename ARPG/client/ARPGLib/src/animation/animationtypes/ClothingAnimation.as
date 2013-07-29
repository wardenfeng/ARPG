package animation.animationtypes
{
	import animation.AnimationItemFactory;

	/**
	 * 玩家皮肤动画
	 * @author warden_feng 2013-6-14
	 */
	public class ClothingAnimation extends PlayerAnimation
	{
		protected var _clothingName:String;

		public function ClothingAnimation(clothingName:String)
		{
			this.clothingName = clothingName;
		}

		public function get clothingName():String
		{
			return _clothingName;
		}

		public function set clothingName(value:String):void
		{
			if (_clothingName != value)
			{
				animationItem = AnimationItemFactory.getClothingAnimationItem(value);
			}
			_clothingName = value;
		}
	}
}
