package modules.preload
{
	
	
	/**
	 * 
	 * @author warden_feng 2013-6-14
	 */
	public class PreLoad
	{
		private static var preloadManager:PrePoadManager;
		
		public static var isPreloadCompleted:Boolean = false;
		
		public static function init():void
		{
			preloadManager = new PrePoadManager();
		}

	}
}