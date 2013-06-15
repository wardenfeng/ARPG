package com.feng.components
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	[Event(name = "click", type = "flash.events.MouseEvent")]

	[Event(name = "mouseDown", type = "flash.events.MouseEvent")]
	[Event(name = "mouseMove", type = "flash.events.MouseEvent")]
	[Event(name = "mouseOut", type = "flash.events.MouseEvent")]
	[Event(name = "mouseOver", type = "flash.events.MouseEvent")]
	[Event(name = "mouseUp", type = "flash.events.MouseEvent")]
	[Event(name = "mouseWheel", type = "flash.events.MouseEvent")]
	public class FButton extends FComponent
	{
		private static var instanceDic:Dictionary = new Dictionary();
		
		public static function getInstance(buttonMc:MovieClip):FButton
		{
			if (instanceDic[buttonMc] == null)
			{
				instanceDic[buttonMc] = new FButton(buttonMc);
			}
			return instanceDic[buttonMc];
		}

		private static const up_frame:int = 1;

		private static const over_frame:int = 2;

		private static const down_frame:int = 3;

		private static const selected_up_frame:int = 4;

		private static const selected_over_frame:int = 5;

		private static const selected_down_frame:int = 6;

		private static const unEnabled_frame:int = 7;

		protected var _label:TextField;

		protected var _over:Boolean = false;

		protected var _down:Boolean = false;

		protected var _selected:Boolean = false;

		public function FButton(buttonMc:MovieClip)
		{
			super(buttonMc);
		}

		override protected function init():void
		{
			super.init();
			_skin.buttonMode = true;
			_skin.useHandCursor = true;

			_skin.addEventListener(MouseEvent.CLICK, onMouseEvent);
			_skin.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			_skin.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			_skin.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			_skin.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			_skin.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			_skin.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseEvent);

		}

		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_skin.gotoAndStop(up_frame);

			if (_skin["labelTxt"])
				_label = _skin["labelTxt"];

			_skin.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			_skin.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////

		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		private function onMouseEvent(event:MouseEvent):void
		{
			dispatchEvent(event);
		}

		/**
		 * Internal mouseOver handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOver(event:MouseEvent):void
		{
			_over = true;
			updateSkin();

			_skin.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}

		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOut(event:MouseEvent):void
		{
			_over = false;
			updateSkin();
			_skin.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}

		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoDown(event:MouseEvent):void
		{
			_down = true;
			updateSkin();

			_skin.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}

		/**
		 * Internal mouseUp handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoUp(event:MouseEvent):void
		{
			_down = false;
			updateSkin();

			_skin.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}

		protected function updateSkin():void
		{
			if (!enabled)
			{
				_skin.gotoAndStop(unEnabled_frame);
			}
			else if (_selected)
			{
				if (_down)
				{
					_skin.gotoAndStop(selected_down_frame);
				}
				else if (_over)
				{
					_skin.gotoAndStop(selected_over_frame);
				}
				else
				{
					_skin.gotoAndStop(selected_up_frame);
				}
			}
			else
			{
				if (_down)
				{
					_skin.gotoAndStop(down_frame);
				}
				else if (_over)
				{
					_skin.gotoAndStop(over_frame);
				}
				else
				{
					_skin.gotoAndStop(up_frame);
				}
			}
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		/**
		 * Sets / gets the label text shown on this Pushbutton.
		 */
		public function set label(str:String):void
		{
			if (_label)
				_label.text = str;
		}

		public function get label():String
		{
			if (_label)
				return _label.text;
			return "";
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;

			updateSkin();
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			updateSkin();
		}
	}
}
