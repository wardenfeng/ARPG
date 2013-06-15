package com.feng.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	[Event(name = "change", type = "flash.events.Event")]
	public class FSlider extends FComponent
	{
		private static var instanceDic:Dictionary = new Dictionary();
		
		public static function getInstance(sliderMc:MovieClip, orientation:String):FSlider
		{
			if (instanceDic[sliderMc] == null)
			{
				instanceDic[sliderMc] = new FSlider(sliderMc, orientation);
			}
			return instanceDic[sliderMc];
		}

		protected var _handle:FButton;

		protected var _back:Sprite;

		protected var _backClick:Boolean = true;

		protected var _value:Number = 0;

		protected var _max:Number = 100;

		protected var _min:Number = 0;

		protected var _orientation:String;

		protected var _tick:Number = 0.01;

		public static const HORIZONTAL:String = "horizontal";

		public static const VERTICAL:String = "vertical";

		public function FSlider(sliderMc:MovieClip, orientation:String)
		{
			_orientation = orientation;
			super(sliderMc);
		}

		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_back = _skin.back;
			_handle = FButton.getInstance(_skin.handle);
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
		}

		/**
		 * Draws the back of the slider.
		 */
		protected function drawBack():void
		{
			if (_backClick)
			{
				_back.addEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
			else
			{
				_back.removeEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
		}

		/**
		 * Draws the handle of the slider.
		 */
		protected function drawHandle():void
		{
			positionHandle();
		}

		/**
		 * Adjusts value to be within minimum and maximum.
		 */
		protected function correctValue():void
		{
			if (_max > _min)
			{
				_value = Math.min(_value, _max);
				_value = Math.max(_value, _min);
			}
			else
			{
				_value = Math.max(_value, _max);
				_value = Math.min(_value, _min);
			}
		}

		/**
		 * Adjusts position of handle when value, maximum or minimum have changed.
		 * TODO: Should also be called when slider is resized.
		 */
		protected function positionHandle():void
		{
			var range:Number;
			if (_orientation == HORIZONTAL)
			{
				range = width - _handle.width;
				_handle.x = (_value - _min) / (_max - _min) * range;
			}
			else
			{
				range = height - _handle.height;
				_handle.y = height - _handle.height - (_value - _min) / (_max - _min) * range;
			}
		}




		///////////////////////////////////
		// public methods
		///////////////////////////////////

		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			drawBack();
			drawHandle();
		}

		/**
		 * Convenience method to set the three main parameters in one shot.
		 * @param min The minimum value of the slider.
		 * @param max The maximum value of the slider.
		 * @param value The value of the slider.
		 */
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			this.minimum = min;
			this.maximum = max;
			this.value = value;
		}



		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		/**
		 * Handler called when user clicks the background of the slider, causing the handle to move to that point. Only active if backClick is true.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onBackClick(event:MouseEvent):void
		{
			if (_orientation == HORIZONTAL)
			{
				_handle.x = _skin.mouseX - _handle.width / 2;
				_handle.x = Math.max(_handle.x, 0);
				_handle.x = Math.min(_handle.x, width - _handle.width);
				_value = _handle.x / (width - _handle.width) * (_max - _min) + _min;
			}
			else
			{
				_handle.y = _skin.mouseY - _handle.height / 2;
				_handle.y = Math.max(_handle.y, 0);
				_handle.y = Math.min(_handle.y, height - _handle.height);
				_value = (height - _handle.height - _handle.y) / (height - _handle.height) * (_max - _min) + _min;
			}
			dispatchEvent(new Event(Event.CHANGE));

		}

		/**
		 * Internal mouseDown handler. Starts dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onDrag(event:MouseEvent):void
		{
			_skin.stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			_skin.stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			if (_orientation == HORIZONTAL)
			{
				_handle.startDrag(false, new Rectangle(0, 0, width - _handle.width, 0));
			}
			else
			{
				_handle.startDrag(false, new Rectangle(0, 0, 0, height - _handle.height));
			}
		}

		/**
		 * Internal mouseUp handler. Stops dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onDrop(event:MouseEvent):void
		{
			_skin.stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			_skin.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			_skin.stopDrag();
		}

		/**
		 * Internal mouseMove handler for when the handle is being moved.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onSlide(event:MouseEvent):void
		{
			var oldValue:Number = _value;
			if (_orientation == HORIZONTAL)
			{
				_value = _handle.x / (width - _handle.width) * (_max - _min) + _min;
			}
			else
			{
				_value = (height - _handle.height - _handle.y) / (height - _handle.height) * (_max - _min) + _min;
			}
			if (_value != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}




		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		/**
		 * Sets / gets whether or not a click on the background of the slider will move the handler to that position.
		 */
		public function set backClick(b:Boolean):void
		{
			_backClick = b;
			invalidate();
		}

		public function get backClick():Boolean
		{
			return _backClick;
		}

		/**
		 * Sets / gets the current value of this slider.
		 */
		public function set value(v:Number):void
		{
			_value = v;
			correctValue();
			positionHandle();

		}

		public function get value():Number
		{
			return Math.round(_value / _tick) * _tick;
		}

		/**
		 * Gets the value of the slider without rounding it per the tick value.
		 */
		public function get rawValue():Number
		{
			return _value;
		}

		/**
		 * Gets / sets the maximum value of this slider.
		 */
		public function set maximum(m:Number):void
		{
			_max = m;
			correctValue();
			positionHandle();
		}

		public function get maximum():Number
		{
			return _max;
		}

		/**
		 * Gets / sets the minimum value of this slider.
		 */
		public function set minimum(m:Number):void
		{
			_min = m;
			correctValue();
			positionHandle();
		}

		public function get minimum():Number
		{
			return _min;
		}

		/**
		 * Gets / sets the tick value of this slider. This round the value to the nearest multiple of this number.
		 */
		public function set tick(t:Number):void
		{
			_tick = t;
		}

		public function get tick():Number
		{
			return _tick;
		}

		override public function get width():Number
		{
			return _back.width;
		}

		override public function get height():Number
		{
			return _back.height;
		}
	}
}
