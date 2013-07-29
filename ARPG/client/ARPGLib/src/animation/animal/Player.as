package animation.animal
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import animation.AnimationEvent;
	import animation.ISceneItem;
	import animation.actioncontroller.PlayerController;
	import animation.animationtypes.ClothingAnimation;
	import animation.animationtypes.WeaponAnimation;
	import animation.configs.ActionType;
	import animation.configs.Direction;
	
	import modules.GameDispatcher;
	import modules.GameEvent;
	import modules.findpath.MapTileModel;
	import modules.gamescene.GameSceneConfig;
	import modules.gamescene.data.PlayerModel;
	import modules.load.Load;

	/**
	 * 动物
	 * @author 风之守望者 2012-6-17
	 */
	public class Player extends Sprite implements ISceneItem
	{
		private function get dispatcher():GameDispatcher
		{
			return GameDispatcher.instance;
		}

		/** 玩家信息 */
		private var _playerinfo:MovieClip;

		private var _destination:Point;

		private var _playerController:PlayerController = new PlayerController();

		private var _mapX:int;

		private var _mapY:int;

		/** 角色皮肤动画 */
		private var _clothingAnimation:ClothingAnimation;

		private var _weaponAnimation:WeaponAnimation;

		public var playerId:int;

		public function Player()
		{
			_weaponAnimation = new WeaponAnimation("20021_2");
			_weaponAnimation.name = "weaponBitmap";
			addChild(_weaponAnimation);

			_clothingAnimation = new ClothingAnimation("10004");
			_clothingAnimation.name = "clothingBitmap";
			addChild(_clothingAnimation);

			_clothingAnimation.playerController = _playerController;
			_weaponAnimation.playerController = _playerController;

			addListeners();
		}

		public function get playerinfo():MovieClip
		{
			if (_playerinfo == null)
			{
				_playerinfo = Load.getInstance("fla.uilibrary.PlayerInfo");
				if (_playerinfo)
				{
					addChild(_playerinfo);
					updateView()
				}
			}
			return _playerinfo;
		}

		private function get playerModel():PlayerModel
		{
			return GameData.playerDic[playerId];
		}

		private function updateView():void
		{
			playerinfo.name_txt.text = playerModel.username;
			playerinfo.hp_txt.text = playerModel.HP + "/100";
			playerinfo.hpline.hpvalue.width = playerModel.HP / 100 * playerinfo.hpline.back.width;
		}

		public function get mapX():int
		{
			if (GameSceneConfig.TILE_WIDTH != 0)
				_mapX = x / GameSceneConfig.TILE_WIDTH;
			return _mapX;
		}

		public function set mapX(value:int):void
		{
			x = value * GameSceneConfig.TILE_WIDTH;
			_mapX = value;
		}

		public function get mapY():int
		{
			if (GameSceneConfig.TILE_HEIGHT != 0)
				_mapY = y / GameSceneConfig.TILE_HEIGHT;
			return _mapY;
		}

		public function set mapY(value:int):void
		{
			y = value * GameSceneConfig.TILE_HEIGHT;
			_mapY = value;
		}

		private function addListeners():void
		{
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);

			dispatcher.addEventListener("config_load_completed", configLoadCompleted);

			_playerController.addEventListener(AnimationEvent.DIRECTION_CHANGE, onDirectionChange);

			dispatcher.addEventListener(GameEvent.HP_UPDATE_NTF, onUpdateHp);
		}

		private function onUpdateHp(event:GameEvent):void
		{
			if (event.data.playerId == playerId)
			{
				updateView();
			}
		}

		private function addedHandler(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function configLoadCompleted(event:Event):void
		{
			x = _mapX * GameSceneConfig.TILE_WIDTH;
			y = _mapY * GameSceneConfig.TILE_HEIGHT;
		}

		private function onDirectionChange(event:Event):void
		{
			switch (playerController.direction)
			{
				case Direction.DIR_DOWN:
					addChildAt(_weaponAnimation, 0);
					break;
				case Direction.DIR_DOWN_RIGHT:
				case Direction.DIR_RIGHT:
				case Direction.DIR_UP_RIGHT:
				case Direction.DIR_UP:
				case Direction.DIR_UP_LEFT:
				case Direction.DIR_LEFT:
				case Direction.DIR_DOWN_LEFT:
					addChildAt(_clothingAnimation, 0);
					break;
			}
		}

		private function onEnterFrame(event:Event):void
		{
			//moveTo();
			//判断是否到达目的
			if (destination && new Point(destination.x - x, destination.y - y).length < playerController.speed)
			{
				destination = null;
				//抛出到达目的事件
				GameDispatcher.instance.dispatchEvent(new Event("animal_move_over"));
			}

			playerController.enterFrame();

			//向目标移动
			x = Math.floor(x + playerController.speed * dirVector.x);
			y = Math.floor(y + playerController.speed * dirVector.y);

			if (playerinfo)
				playerinfo.visible = true;
		}

		/** 目的地 */
		public function get destination():Point
		{
			return _destination;
		}

		public function set clothing(value:String):void
		{
			_clothingAnimation.clothingName = value;
		}

		public function get clothing():String
		{
			return _clothingAnimation.clothingName;
		}

		private function get playerController():PlayerController
		{
			return _playerController;
		}

		/**
		 * @private
		 */
		public function set destination(value:Point):void
		{
			//目的地为null时，设置为站立
			if (value == null)
			{
				_destination = null;
				playerController.action = ActionType.STAND;
				return;
			}
			_destination = MapTileModel.realCoordinate(value.x, value.y);

			var moveDirection:int = Direction.getDirection(dirVector);
			//设置角色移动方式与朝向
			playerController.action = ActionType.RUN;
			playerController.direction = moveDirection;
		}

		public function get dirVector():Point
		{
			if (_destination == null)
				return new Point();
			//初始化方向上的单位速度
			var dir:Point = _destination.subtract(new Point(x, y));
			dir.normalize(1);
			return dir;
		}

		public function set action(value:int):void
		{
			playerController.action = value;
		}

		public function set direction(value:int):void
		{
			playerController.direction = value;
		}

		public function get floorX():Number
		{
			return x;
		}

		public function get floorY():Number
		{
			return y;
		}
	}
}
