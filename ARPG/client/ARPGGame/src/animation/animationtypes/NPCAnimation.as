package animation.animationtypes
{
	import animation.AnimationItemFactory;

	/**
	 * NPC动画
	 * @author warden feng 2013-6-14
	 */
	public class NPCAnimation extends LoopAnimation
	{
		protected var _npcName:String;

		public function NPCAnimation(npcName:String)
		{
			this.npcName = npcName;
			init();
		}

		public function get npcName():String
		{
			return _npcName;
		}

		public function set npcName(value:String):void
		{
			if (_npcName != value)
			{
				var url:String = GlobalData.getNPCPath(value);

				animationItem = AnimationItemFactory.getAnimationItem(url);
			}
			_npcName = value;
		}
	}
}
