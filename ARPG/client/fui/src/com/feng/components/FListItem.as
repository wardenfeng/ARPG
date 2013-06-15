package com.feng.components
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class FListItem extends FComponent
	{
		private static var instanceDic:Dictionary = new Dictionary();

		public static function getInstance(listItemMc:MovieClip):FListItem
		{
			if (instanceDic[listItemMc] == null)
			{
				instanceDic[listItemMc] = new FListItem(listItemMc);
			}
			return instanceDic[listItemMc];
		}

		protected var _data:Object;

		protected var _itemDefaultBack:DisplayObject;

		protected var _itemAlternateBack:DisplayObject;

		protected var _itemRolloverBack:DisplayObject;

		protected var _itemSelectedBack:DisplayObject;

		protected var _selected:Boolean = false;

		protected var _mouseOver:Boolean = false;

		protected var _alternate:Boolean = false;

		public function FListItem(listItemMc:MovieClip, data:Object = null)
		{
			_data = data;
			super(listItemMc);
		}

		/**
		 * Initilizes the component.
		 */
		override protected function init():void
		{
			super.init();

			_skin.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}

		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected override function addChildren():void
		{
			super.addChildren();
			_itemDefaultBack = _skin.itemDefaultBack;
			_itemAlternateBack = _skin.itemAlternateBack;
			_itemRolloverBack = _skin.itemRolloverBack;
			_itemSelectedBack = _skin.itemSelectedBack;
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////

		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			_itemDefaultBack.visible = !_alternate;
			_itemAlternateBack.visible = _alternate;
			_itemRolloverBack.visible = _mouseOver;
			_itemSelectedBack.visible = _selected;

			//更新界面数据
			updateView();
		}

		public function updateView():void
		{

		}


		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		/**
		 * Called when the user rolls the mouse over the item. Changes the background color.
		 */
		protected function onMouseOver(event:MouseEvent):void
		{
			_skin.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_mouseOver = true;
			invalidate();
		}

		/**
		 * Called when the user rolls the mouse off the item. Changes the background color.
		 */
		protected function onMouseOut(event:MouseEvent):void
		{
			_skin.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_mouseOver = false;
			invalidate();
		}


		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		/**
		 * Sets/gets the string that appears in this item.
		 */
		public function set data(value:Object):void
		{
			_data = value;
			invalidate();
		}

		public function get data():Object
		{
			return _data;
		}

		/**
		 * Sets/gets whether or not this item is selected.
		 */
		public function set selected(value:Boolean):void
		{
			_selected = value;
			invalidate();
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set alternate(value:Boolean):void
		{
			_alternate = value;
			invalidate();
		}

		public function get alternate():Boolean
		{
			return _alternate;
		}
	}
}
