package com.feng.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	[Event(name = "select", type = "flash.events.Event")]
	public class FList extends FComponent
	{
		private static var instanceDic:Dictionary = new Dictionary();

		public static function getInstance(listMc:MovieClip):FList
		{
			if (instanceDic[listMc] == null)
			{
				instanceDic[listMc] = new FList(listMc);
			}
			return instanceDic[listMc];
		}

		public static const ITEM_NAME:String = "item";

		protected var _items:Array;

		protected var _listItems:Array = [];

		protected var _itemHolder:Sprite;

		protected var _panel:FPanel;

		protected var _listItemClass:Class = FListItem;

		protected var _scrollbar:FScrollBar;

		protected var _selectedIndex:int = -1;

		protected var _alternateRows:Boolean = false;

		public function FList(listMc:MovieClip)
		{
			_items = new Array();

			super(listMc);
		}

		/**
		 * Initilizes the component.
		 */
		override protected function init():void
		{
			super.init();
			_skin.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(Event.RESIZE, onResize);
			makeListItems();
			fillItems();
		}

		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected override function addChildren():void
		{
			super.addChildren();
			_panel = FPanel.getInstance(_skin.panel);
			_itemHolder = _panel.content;

			_scrollbar = new FScrollBar(_skin.scrollbar, FSlider.VERTICAL);
			_scrollbar.addEventListener(Event.CHANGE, onScroll);
			_scrollbar.setSliderParams(0, 0, 0);
		}

		/**
		 * Creates all the list items based on data.
		 */
		protected function makeListItems():void
		{
			var listItemMc:MovieClip;
			var listItem:FListItem;
			for (var i:int = 0; i < _itemHolder.numChildren; i++)
			{
				listItemMc = _itemHolder.getChildAt(i) as MovieClip;
				if (listItemMc && listItemMc.name.indexOf(ITEM_NAME) != -1)
				{
					var index:int = int(listItemMc.name.substring(listItemMc.name.indexOf(ITEM_NAME) + ITEM_NAME.length));
					listItem = _listItemClass.getInstance(listItemMc);
					listItem.x = 0;
					listItem.y = index * listItemHeight;
					_listItems[index] = listItem;
				}
			}
		}

		protected function fillItems():void
		{
			var offset:int = _scrollbar.value;
			var numItems:int = _listItems.length;

			for (var i:int = 0; i < numItems; i++)
			{
				var item:FListItem = _listItems[i] as FListItem;
				if (offset + i < _items.length)
				{
					item.data = _items[offset + i];
					item.visible = true;
				}
				else
				{
					item.data = null;
					item.visible = false;
				}
				if (_alternateRows)
				{
					item.alternate = (offset + i) % 2 != 0;
				}
				else
				{
					item.alternate = false;
				}
				if (offset + i == _selectedIndex)
				{
					item.selected = true;
				}
				else
				{
					item.selected = false;
				}
			}
		}

		/**
		 * If the selected item is not in view, scrolls the list to make the selected item appear in the view.
		 */
		protected function scrollToSelection():void
		{
			var numItems:int = _listItems.length;
			if (_selectedIndex != -1)
			{
				if (_scrollbar.value > _selectedIndex)
				{
//                    _scrollbar.value = _selectedIndex;
				}
				else if (_scrollbar.value + numItems < _selectedIndex)
				{
					_scrollbar.value = _selectedIndex - numItems + 1;
				}
			}
			else
			{
				_scrollbar.value = 0;
			}
			fillItems();
		}



		///////////////////////////////////
		// public methods
		///////////////////////////////////

		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			_selectedIndex = Math.min(_selectedIndex, _items.length - 1);

			// scrollbar
			var contentHeight:Number = _items.length * listItemHeight;
			_scrollbar.setThumbPercent(_panel.height / contentHeight);
			var pageSize:Number = Math.floor(_panel.height / listItemHeight);
			_scrollbar.maximum = Math.max(0, _items.length - pageSize);
			_scrollbar.pageSize = pageSize;
			_scrollbar.draw();
			scrollToSelection();
		}

		/**
		 * Adds an item to the list.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 */
		public function addItem(item:Object):void
		{
			_items.push(item);
			draw();
			fillItems();
		}

		/**
		 * Adds an item to the list at the specified index.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 * @param index The index at which to add the item.
		 */
		public function addItemAt(item:Object, index:int):void
		{
			index = Math.max(0, index);
			index = Math.min(_items.length, index);
			_items.splice(index, 0, item);
			draw();
			fillItems();
		}

		/**
		 * Removes the referenced item from the list.
		 * @param item The item to remove. If a string, must match the item containing that string. If an object, must be a reference to the exact same object.
		 */
		public function removeItem(item:Object):void
		{
			var index:int = _items.indexOf(item);
			removeItemAt(index);
		}

		/**
		 * Removes the item from the list at the specified index
		 * @param index The index of the item to remove.
		 */
		public function removeItemAt(index:int):void
		{
			if (index < 0 || index >= _items.length)
				return;
			_items.splice(index, 1);
			draw();
			fillItems();
		}

		/**
		 * Removes all items from the list.
		 */
		public function removeAll():void
		{
			_items.length = 0;
			invalidate();
			fillItems();
		}





		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		/**
		 * Called when a user selects an item in the list.
		 */
		protected function onSelect(event:Event):void
		{
			if (!(event.target is FListItem))
				return;

			var offset:int = _scrollbar.value;

			for (var i:int = 0; i < _itemHolder.numChildren; i++)
			{
				if (_itemHolder.getChildAt(i) == event.target)
					_selectedIndex = i + offset;
				FListItem(_itemHolder.getChildAt(i)).selected = false;
			}
			FListItem(event.target).selected = true;
			dispatchEvent(new Event(Event.SELECT));
		}

		/**
		 * Called when the user scrolls the scroll bar.
		 */
		protected function onScroll(event:Event):void
		{
			fillItems();
		}

		/**
		 * Called when the mouse wheel is scrolled over the component.
		 */
		protected function onMouseWheel(event:MouseEvent):void
		{
			_scrollbar.value -= event.delta;
			fillItems();
		}

		protected function onResize(event:Event):void
		{
			makeListItems();
			fillItems();
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		/**
		 * Sets / gets the index of the selected list item.
		 */
		public function set selectedIndex(value:int):void
		{
			if (value >= 0 && value < _items.length)
			{
				_selectedIndex = value;
//				_scrollbar.value = _selectedIndex;
			}
			else
			{
				_selectedIndex = -1;
			}
			invalidate();
			dispatchEvent(new Event(Event.SELECT));
		}

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		/**
		 * Sets / gets the item in the list, if it exists.
		 */
		public function set selectedItem(item:Object):void
		{
			var index:int = _items.indexOf(item);
//			if(index != -1)
//			{
			selectedIndex = index;
			invalidate();
			dispatchEvent(new Event(Event.SELECT));
//			}
		}

		public function get selectedItem():Object
		{
			if (_selectedIndex >= 0 && _selectedIndex < _items.length)
			{
				return _items[_selectedIndex];
			}
			return null;
		}

		public function get listItemHeight():Number
		{
			if (_listItems.length > 0)
			{
				return _listItems[0].height;
			}
			return 20;
		}

		/**
		 * Sets / gets the list of items to be shown.
		 */
		public function set items(value:Array):void
		{
			_items = value;
			invalidate();
		}

		public function get items():Array
		{
			return _items;
		}

		/**
		 * Sets / gets the class used to render list items. Must extend ListItem.
		 */
		public function set listItemClass(value:Class):void
		{
			_listItemClass = value;
			makeListItems();
			invalidate();
		}

		public function get listItemClass():Class
		{
			return _listItemClass;
		}

		/**
		 * Sets / gets whether or not every other row will be colored with the alternate color.
		 */
		public function set alternateRows(value:Boolean):void
		{
			_alternateRows = value;
			invalidate();
		}

		public function get alternateRows():Boolean
		{
			return _alternateRows;
		}

		/**
		 * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
		 */
		public function set autoHideScrollBar(value:Boolean):void
		{
			_scrollbar.autoHide = value;
		}

		public function get autoHideScrollBar():Boolean
		{
			return _scrollbar.autoHide;
		}

	}
}
