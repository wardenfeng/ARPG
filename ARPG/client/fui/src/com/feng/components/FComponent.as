package com.feng.components
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	[Event(name = "draw", type = "flash.events.Event")]
	public class FComponent extends EventDispatcher
	{
		private static var instanceDic:Dictionary = new Dictionary();

		public static function getInstance(componentMc:MovieClip):FComponent
		{
			if (instanceDic[componentMc] == null)
			{
				instanceDic[componentMc] = new FComponent(componentMc);
			}
			return instanceDic[componentMc];
		}

		protected var _skin:MovieClip;

		public static const DRAW:String = "draw";

		public function FComponent(componentMc:MovieClip)
		{
			_skin = componentMc;

			init();
		}

		/**
		 * Initilizes the component.
		 */
		protected function init():void
		{
			addChildren();
			invalidate();
		}

		/**
		 * Overriden in subclasses to create child display objects.
		 */
		protected function addChildren():void
		{

		}

		/**
		 * Marks the component to be redrawn on the next frame.
		 */
		protected function invalidate():void
		{
//			draw();
			_skin.addEventListener(Event.ENTER_FRAME, onInvalidate);
		}




		///////////////////////////////////
		// public methods
		///////////////////////////////////

		/**
		 * Utility method to set up usual stage align and scaling.
		 */
		public static function initStage(stage:Stage):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		/**
		 * Moves the component to the specified position.
		 * @param xpos the x position to move the component
		 * @param ypos the y position to move the component
		 */
		public function move(xpos:Number, ypos:Number):void
		{
			x = Math.round(xpos);
			y = Math.round(ypos);
		}

		public function setSize(w:Number, h:Number):void
		{
			_skin.width = w;
			_skin.height = h;
			dispatchEvent(new Event(Event.RESIZE));
			invalidate();
		}

		/**
		 * Abstract draw function.
		 */
		public function draw():void
		{
			dispatchEvent(new Event(FComponent.DRAW));
		}

		public function startDrag(lockCenter:Boolean, bounds:Rectangle):void
		{
			_skin.startDrag(lockCenter, bounds);
		}



		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		/**
		 * Called one frame after invalidate is called.
		 */
		protected function onInvalidate(event:Event):void
		{
			_skin.removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		public function set width(w:Number):void
		{
			_skin.width = w;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}

		public function get width():Number
		{
			return _skin.width;
		}

		public function set height(h:Number):void
		{
			_skin.height = h;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}

		public function get height():Number
		{
			return _skin.height;
		}

		/**
		 * Overrides the setter for x to always place the component on a whole pixel.
		 */
		public function set x(value:Number):void
		{
			_skin.x = Math.round(value);
		}

		public function get x():Number
		{
			return _skin.x;
		}

		/**
		 * Overrides the setter for y to always place the component on a whole pixel.
		 */
		public function set y(value:Number):void
		{
			_skin.y = Math.round(value);
		}

		public function get y():Number
		{
			return _skin.y;
		}

		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		public function set enabled(value:Boolean):void
		{
			_skin.tabEnabled = _skin.mouseEnabled = _skin.mouseChildren = _skin.enabled = value;
		}

		public function get enabled():Boolean
		{
			return _skin.enabled;
		}

		public function set visible(value:Boolean):void
		{
			_skin.visible = value;
		}

		public function get visible():Boolean
		{
			return _skin.visible;
		}

		public function get skin():MovieClip
		{
			return _skin;
		}
	}
}
