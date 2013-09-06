package modules.chat
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import modules.GameEvent;
	import modules.ViewManager;
	import modules.load.Load;
	import modules.load.LoadEvent;

	import utils.PopupManager;

	/**
	 *
	 * @author warden_feng 2013-9-6
	 */
	public class ChatViewManager extends ViewManager
	{
		private var loading:Boolean = false;

		private var isLoad:Boolean = false;

		private var mainUI:MovieClip;

		public function ChatViewManager()
		{
			dispatcher.addEventListener(ChatEvent.CHAT_SHOW, onGameEvent);
		}

		override protected function init():void
		{
			if (loading)
				return;

			if (!isLoad)
			{
				loading = true;
				dispatcher.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, {urls: [Chat.viewPath], allItemsLoaded: function():void
				{
					loading = false;
					isLoad = true;
					init();
				}}));
				return;
			}

			mainUI = Load.getInstance("fla.ui.ChatUI");
			mainUI.name = "ChatUI";

			mainUI.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			mainUI.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			Chat.isInit = true;

			show();
		}

		override protected function show():void
		{
			if (!Chat.isInit)
			{
				init();
				return;
			}

			updateView();

			Chat.isShow = true;

			PopupManager.addContentUI(mainUI);
			mainUI.x = 0;
			mainUI.y = UIAllRefer.stage.stageHeight - mainUI.height;
		}

		override protected function updateView():void
		{

		}

		override protected function close():void
		{
			PopupManager.removePopUp(mainUI);

			Chat.isShow = false;
		}

		override protected function onAddToStage(event:Event):void
		{
//			dispatcher.addEventListener(ChatEvent.LOGIN_SUCCEED, onLoginSucceed);

			mainUI.btn_send.addEventListener(MouseEvent.CLICK, onClick);
		}

		override protected function onRemovedFromStage(event:Event):void
		{
			mainUI.btn_send.removeEventListener(MouseEvent.CLICK, onClick);
		}

		protected function onGameEvent(event:GameEvent):void
		{
			switch (event.type)
			{
				case ChatEvent.CHAT_SHOW:
					show();
					break;
			}
		}

		protected function onClick(event:MouseEvent):void
		{
			switch (event.currentTarget)
			{
				case mainUI.btn_send:

					break;
			}
		}
	}
}
