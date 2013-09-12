package modules.chat
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import communication.arpg.ArpgMsgEvent;
	
	import modules.GameEvent;
	import modules.ViewManager;
	import modules.chat.model.ChatModel;
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
			dispatcher.addEventListener(ChatEvent.SPEAK, onGameEvent);

			mainUI.enterBtn.addEventListener(MouseEvent.CLICK, onClick);
			mainUI.inputTxt.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}

		override protected function onRemovedFromStage(event:Event):void
		{
			dispatcher.removeEventListener(ChatEvent.SPEAK, onGameEvent);
			mainUI.btn_send.removeEventListener(MouseEvent.CLICK, onClick);
			mainUI.inputTxt.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}

		protected function onGameEvent(event:GameEvent):void
		{
			switch (event.type)
			{
				case ChatEvent.CHAT_SHOW:
					show();
					break;
				case ChatEvent.SPEAK:
					speak(event.data);
					break;
			}
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				sendMsg();
			}
		}

		private function speak(data:ChatModel):void
		{
			mainUI.chatAreaTxt.appendText(data.username + ":" + data.msg + "\n");
		}

		protected function onClick(event:MouseEvent):void
		{
			switch (event.currentTarget)
			{
				case mainUI.enterBtn:
					sendMsg();
					break;
			}
		}
		
		private function sendMsg():void
		{
			if(mainUI.inputTxt.text.length > 0)
			{
				dispatcher.dispatchEvent(new ArpgMsgEvent(ARPGProto.ASID_CHAT_REQ, {msg: mainUI.inputTxt.text}));
			}
			mainUI.inputTxt.text = "";
		}		
	}
}
