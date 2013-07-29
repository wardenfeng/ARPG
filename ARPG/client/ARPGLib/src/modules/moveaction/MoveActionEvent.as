package modules.moveaction
{
	import modules.GameEvent;

	/**
	 * 移动动作事件
	 * @author warden_feng 2012-7-3
	 */
	public class MoveActionEvent extends GameEvent
	{
		public static const HERO_MOVE_REQ:String = "heroMoveReq";
		
		/**
		 * 主角开始移动
		 */
		public static const HERO_START_MOVE : String = "heroStartMove";

		/**
		 * 主角单步行走完成
		 */
		public static const HERO_STEP_COMPLETED : String = "heroStepCompleted";
		
		/**
		 * 主角到达目的地移动结束
		 */
		public static const HERO_END_MOVE : String = "heroEndMove";
		
		
		/**
		 * 移动动作事件
		 * @param type 事件类型
		 * @param data 附加数据
		 */
		public function MoveActionEvent(type : String, data : Object = null)
		{
			super(type,data);
		}
	}
}
