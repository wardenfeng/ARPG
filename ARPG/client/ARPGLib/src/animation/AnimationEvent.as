package animation
{
	import modules.GameEvent;
	
	
	/**
	 * 
	 * @author warden feng 2013-6-7
	 */
	public class AnimationEvent extends GameEvent
	{
		/** 动画改变 */
		public static const CHANGE:String = "change";
		
		/** 完成一周 */
		public static const LOOPED:String = "looped";
		
		/** 改变方向 */
		public static const DIRECTION_CHANGE:String = "directionChange";
		
		/** 改变动作 */
		public static const ACTION_CHANGE:String = "actionChange";
		
		
		public function AnimationEvent(type:String, data:*=null)
		{
			super(type, data);
		}
	}
}