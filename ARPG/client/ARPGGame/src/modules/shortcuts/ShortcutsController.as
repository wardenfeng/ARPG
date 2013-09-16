package modules.shortcuts
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import communication.arpg.ArpgMsgEvent;

	import modules.GameDispatcher;
	import modules.gamescene.GameSceneEvent;
	import modules.scenemap.ScenemapEvent;


	/**
	 * 快捷键管理者
	 * @author warden_feng 2012-7-2
	 */
	public class ShortcutsController
	{
		private function get dispatcher():GameDispatcher
		{
			return GameDispatcher.instance;
		}

		public function ShortcutsController()
		{
			UIAllRefer.game.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				//打开或关闭地图
				case Keyboard.M:
					dispatcher.dispatchEvent(new ScenemapEvent(ScenemapEvent.SCENEMAP_SHOW_CLOSE));
					break;
				case Keyboard.NUMBER_1:
					var castSkillObject:Object = {};
					//获取鼠标所在场景坐标
					dispatcher.dispatchEvent(new GameSceneEvent(GameSceneEvent.GET_SKILL_TARGET, castSkillObject));
					castSkillObject.skillId = 1;
					dispatcher.dispatchEvent(new ArpgMsgEvent(ARPGProto.ASID_CAST_SKILL_REQ, castSkillObject));
					break;
			}
		}

		// ----------------------------------------
		//
		//		单例模式
		//
		// ----------------------------------------
		private static var _instance:ShortcutsController;

		public static function start():ShortcutsController
		{
			return instance;
		}

		public static function get instance():ShortcutsController
		{
			if (_instance == null)
				_instance = new ShortcutsController();
			return _instance;
		}
	}
}
