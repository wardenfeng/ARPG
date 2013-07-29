package modules.prompt
{
	/**
	 * 
	 * @author warden_feng 2013-7-25
	 */
	public class Prompt
	{
		private static var promptUIManager:PromptUIManager;
		
		public static var isPromptResCompleted:Boolean = false;
		
		public static function init():void
		{
			promptUIManager = new PromptUIManager();
		}
	}
}