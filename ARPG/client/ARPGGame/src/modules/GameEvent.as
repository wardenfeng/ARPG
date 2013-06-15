package modules
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		/**
		 * 显示大厅界面 
		 */		
		public static const SHOW_LOBBY:String = "showLobby";
		
		/**
		 * 模块初始化完成 
		 */		
		public static const MOUDLES_COMPLETED:String = "moudlesCompleted";

		/**
		 * 显示警告信息
		 **/
		public static const SHOW_INFO:String = "showInfo";
		
		/**
		 * 显示警告信息
		 **/
		public static const SHOW_WARN_INFO:String = "showWarnInfo";
		
		/**
		 * 显示等待信息
		 **/
		public static const SHOW_WAIT_INFO:String = "showWaitInfo";
		
		/**
		 * 切换语言
		 **/
		public static const CHANGE_LANGUAGE:String = "changeLanguage"
		
		/**
		 * 显示提示信息
		 **/
		public static const SHOW_INFORMATION:String = "showInformation";
		
		/**
		 * 关闭提示面板
		 **/
		public static const CLOSE_INFORMATION:String = "closeInformation";
		
		/**
		 * 显示加载信息
		 **/
		public static const SHOW_LOAD_INFO:String = "showLoadInfo";
		
		/**
		 * 进入了桌子 
		 */		
		public static const ENTERED_TABLE:String = "enteredTable";
		
		/**
		 * 离开了桌子 
		 */		
		public static const LEAVE_TABLE:String = "leaveTable";
		
		/**
		 * 显示大厅分页
		 */
		public static const SHOW_TAB_LOBBY:String = "showTabLobby";
		
		/**
		 * 显示桌子分页
		 */
		public static const SHOW_TAB_TABLE:String = "showTabTable";
		
		/**
		 * 添加周期执行函数 
		 */		
		public static const ADD_CYCLE_FUNCTION:String = "addCycleFunction";
		
		/**
		 *麻将服连接关闭 
		 */		
		public static const majiang_server_close:String = "majiangServerClose";
		
		/**
		 * 添加 回放按钮 
		 */
		public static const ADD_REPLAY_BUTTON:String = "addReplayButton";
		
		/**
		 * 回放录像 
		 */		
		public static const DO_REPLAY:String = "doReplay";
		
		public var data:*;

		public function GameEvent(type:String,data:* = null)
		{
			super(type);
			this.data = data;
		}
	}
}