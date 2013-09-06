package
{
	import com.junkbyte.console.Cc;
	import com.junkbyte.console.addons.autoFocus.CommandLineAutoFocusAddon;
	import com.junkbyte.console.addons.displaymap.DisplayMapAddon;
	
	import flash.display.DisplayObject;

	public class MyCC
	{
		/**
		 * 初始化控制台
		 **/
		public static function initFlashConsole(display : DisplayObject, password : String = "`") : void
		{
			//
			// SETUP - only required once
			//
			// you must modify the styles before starting console.
			Cc.config.style.big(); // BIGGER text. this modifies the config variables such as traceFontSize, menuFontSize
			Cc.config.style.whiteBase(); // Black on white. this modifies the config variables such as priority0, priority1, etc
			Cc.config.style.backgroundAlpha = 0.6; // makes it non-transparent background.

			Cc.startOnStage(display, password); // "`" - change for password. This will start hidden
			Cc.commandLine = true; // enable command line
			Cc.config.commandLineAllowed = true;

			Cc.width = display.stage.stageWidth;
			Cc.height = display.stage.stageHeight;

			DisplayMapAddon.registerCommand();
			DisplayMapAddon.addToMenu("DM"); // DisplayMapper. click on DM button at top menu to start.

			CommandLineAutoFocusAddon.registerToConsole(); // this addon auto focus to commandline when console becomes visible
		}
	}
}
