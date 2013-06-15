package com.feng.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * Helper class for the slider portion of the scroll bar.
	 */
	public class FScrollSlider extends FSlider
	{
		private static var instanceDic:Dictionary = new Dictionary();

		public static function getInstance(scrollSliderMc:MovieClip, orientation:String):FScrollSlider
		{
			if (instanceDic[scrollSliderMc] == null)
			{
				instanceDic[scrollSliderMc] = new FScrollSlider(scrollSliderMc, orientation);
			}
			return instanceDic[scrollSliderMc];
		}

		protected var _thumbPercent:Number = 1.0;

		public function FScrollSlider(scrollSliderMc:MovieClip, orientation:String)
		{
			super(scrollSliderMc, orientation);
		}

		/**
		 * Initializes the component.
		 */
		protected override function init():void
		{
			super.init();
			setSliderParams(1, 100, 0);
			backClick = true;
		}

		/**
		 * Draws the handle of the slider.
		 */
		override protected function drawHandle():void
		{
			var size:Number;
			if (_orientation == HORIZONTAL)
			{
				size = Math.round(width * _thumbPercent);
				size = Math.max(height, size);

				_handle.width = size;
			}
			else
			{
				size = Math.round(height * _thumbPercent);
				size = Math.max(width, size);

				_handle.height = size;
			}

			positionHandle();
		}

		/**
		 * Adjusts position of handle when value, maximum or minimum have changed.
		 * TODO: Should also be called when slider is resized.
		 */
		protected override function positionHandle():void
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
				_handle.y = (_value - _min) / (_max - _min) * range;
			}
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////

		/**
		 * Sets the percentage of the size of the thumb button.
		 */
		public function setThumbPercent(value:Number):void
		{
			_thumbPercent = Math.min(value, 1.0);
			invalidate();
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		/**
		 * Handler called when user clicks the background of the slider, causing the handle to move to that point. Only active if backClick is true.
		 * @param event The MouseEvent passed by the system.
		 */
		protected override function onBackClick(event:MouseEvent):void
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
				_value = _max - (height - _handle.height - _handle.y) / (height - _handle.height) * (_max - _min);
			}
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * Internal mouseDown handler. Starts dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected override function onDrag(event:MouseEvent):void
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
		 * Internal mouseMove handler for when the handle is being moved.
		 * @param event The MouseEvent passed by the system.
		 */
		protected override function onSlide(event:MouseEvent):void
		{
			var oldValue:Number = _value;
			if (_orientation == HORIZONTAL)
			{
				if (width == _handle.width)
				{
					_value = _min;
				}
				else
				{
					_value = _handle.x / (width - _handle.width) * (_max - _min) + _min;
				}
			}
			else
			{
				if (height == _handle.height)
				{
					_value = _min;
				}
				else
				{
					_value = _handle.y / (height - _handle.height) * (_max - _min) + _min;
				}
			}
			if (_value != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}



		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		public function get thumbPercent():Number
		{
			return _thumbPercent;
		}
	}

}
