package com.feng.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	[Event(name = "change", type = "flash.events.Event")]
	public class FScrollBar extends FComponent
	{

		private static var instanceDic:Dictionary = new Dictionary();

		public static function getInstance(scrollBarMc:MovieClip, orientation:String):FScrollBar
		{
			if (instanceDic[scrollBarMc] == null)
			{
				instanceDic[scrollBarMc] = new FScrollBar(scrollBarMc, orientation);
			}
			return instanceDic[scrollBarMc];
		}


		protected const DELAY_TIME:int = 500;

		protected const REPEAT_TIME:int = 100;

		protected const UP:String = "up";

		protected const DOWN:String = "down";

		protected var _autoHide:Boolean = false;

		protected var _upButton:FButton;

		protected var _downButton:FButton;

		protected var _scrollSlider:FScrollSlider;

		protected var _orientation:String;

		protected var _lineSize:int = 1;

		protected var _delayTimer:Timer;

		protected var _repeatTimer:Timer;

		protected var _direction:String;

		protected var _shouldRepeat:Boolean = false;

		protected var _pageSize:int = 1;

		public function FScrollBar(scrollBarMc:MovieClip, orientation:String)
		{
			_orientation = orientation;
			super(scrollBarMc)
		}

		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();

			_delayTimer = new Timer(DELAY_TIME, 1);
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer = new Timer(REPEAT_TIME);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
		}

		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_upButton = FButton.getInstance(_skin.upButton);
			_upButton.addEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
			_downButton = FButton.getInstance(_skin.downButton);
			_downButton.addEventListener(MouseEvent.MOUSE_DOWN, onDownClick);

			_scrollSlider = new FScrollSlider(_skin.scrollSlider, _orientation);
			_scrollSlider.addEventListener(Event.CHANGE, onChange);
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////

		/**
		 * Convenience method to set the three main parameters in one shot.
		 * @param min The minimum value of the slider.
		 * @param max The maximum value of the slider.
		 * @param value The value of the slider.
		 */
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			_scrollSlider.setSliderParams(min, max, value);
		}

		/**
		 * Sets the percentage of the size of the thumb button.
		 */
		public function setThumbPercent(value:Number):void
		{
			_scrollSlider.setThumbPercent(value);
		}

		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			_scrollSlider.draw();
			if (_autoHide)
			{
				visible = _scrollSlider.thumbPercent < 1.0;
			}
			else
			{
				visible = true;
			}
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		/**
		 * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
		 */
		public function set autoHide(value:Boolean):void
		{
			_autoHide = value;
			invalidate();
		}

		public function get autoHide():Boolean
		{
			return _autoHide;
		}

		/**
		 * Sets / gets the current value of this scroll bar.
		 */
		public function set value(v:Number):void
		{
			_scrollSlider.value = v;
		}

		public function get value():Number
		{
			return _scrollSlider.value;
		}

		/**
		 * Sets / gets the minimum value of this scroll bar.
		 */
		public function set minimum(v:Number):void
		{
			_scrollSlider.minimum = v;
		}

		public function get minimum():Number
		{
			return _scrollSlider.minimum;
		}

		/**
		 * Sets / gets the maximum value of this scroll bar.
		 */
		public function set maximum(v:Number):void
		{
			_scrollSlider.maximum = v;
		}

		public function get maximum():Number
		{
			return _scrollSlider.maximum;
		}

		/**
		 * Sets / gets the amount the value will change when up or down buttons are pressed.
		 */
		public function set lineSize(value:int):void
		{
			_lineSize = value;
		}

		public function get lineSize():int
		{
			return _lineSize;
		}

		/**
		 * Sets / gets the amount the value will change when the back is clicked.
		 */
		public function set pageSize(value:int):void
		{
			_pageSize = value;
			invalidate();
		}

		public function get pageSize():int
		{
			return _pageSize;
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		protected function onUpClick(event:MouseEvent):void
		{
			goUp();
			_shouldRepeat = true;
			_direction = UP;
			_delayTimer.start();
			_skin.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}

		protected function goUp():void
		{
			_scrollSlider.value -= _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}

		protected function onDownClick(event:MouseEvent):void
		{
			goDown();
			_shouldRepeat = true;
			_direction = DOWN;
			_delayTimer.start();
			_skin.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}

		protected function goDown():void
		{
			_scrollSlider.value += _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}

		protected function onMouseGoUp(event:MouseEvent):void
		{
			_delayTimer.stop();
			_repeatTimer.stop();
			_shouldRepeat = false;
		}

		protected function onChange(event:Event):void
		{
			dispatchEvent(event);
		}

		protected function onDelayComplete(event:TimerEvent):void
		{
			if (_shouldRepeat)
			{
				_repeatTimer.start();
			}
		}

		protected function onRepeat(event:TimerEvent):void
		{
			if (_direction == UP)
			{
				goUp();
			}
			else
			{
				goDown();
			}
		}
	}
}
