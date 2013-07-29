package animation.animationtypes
{
	import animation.AnimationItemFactory;

	/**
	 * 玩家武器动画
	 * @author warden_feng 2013-6-14
	 */
	public class WeaponAnimation extends PlayerAnimation
	{
		protected var _weaponName:String;

		public function WeaponAnimation(weaponName:String)
		{
			this.weaponName = weaponName;
		}

		public function get weaponName():String
		{
			return _weaponName;
		}

		public function set weaponName(value:String):void
		{
			if (_weaponName != value)
			{
				animationItem = AnimationItemFactory.getWeaponAnimationItem(value);
			}
			_weaponName = value;
		}
	}
}
