package animation.animal
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	import animation.ISceneItem;
	import animation.animationtypes.MonsterAnimation;

	import modules.gamescene.GameSceneConfig;
	import modules.gamescene.data.MonsterModel;
	import modules.load.Load;

	/**
	 *
	 * @author warden feng 2013-7-6
	 */
	public class Monster extends Sprite implements ISceneItem
	{
		/** 怪物信息 */
		private var _monsterinfo:MovieClip;

		private var _monsterId:int;

		private var _mapX:int;

		private var _mapY:int;

		private var monsterAnimation:MonsterAnimation;

		private var _typeId:int;

		private var enemyInfo:Object;

		private var modelInfo:Object;

		private var model:Object;

		public function Monster()
		{
			monsterAnimation = MonsterAnimation.defaultAnimation;

			//如果方向为3则翻转图片
			addChild(monsterAnimation);

			addListeners();
		}

		public function get monsterId():int
		{
			return _monsterId;
		}

		public function set monsterId(value:int):void
		{
			_monsterId = value;
			name = "monster" + _monsterId;

			mapX = monsterModel.mapX;
			mapY = monsterModel.mapY;
			typeId = monsterModel.typeId;
		}

		private function get monsterModel():MonsterModel
		{
			return GameData.monsterDic[_monsterId];
		}

		public function get typeId():int
		{
			return _typeId;
		}

		public function set typeId(value:int):void
		{
			_typeId = value;
			enemyInfo = GameData.enemyDic[_typeId];
			modelInfo = GameData.modelInfoDic[enemyInfo.skinid];
			model = GameData.modelDic["resources/enemy/" + modelInfo.mid + ".swf"];

			if (monsterAnimation)
				removeChild(monsterAnimation);
			monsterAnimation = new MonsterAnimation(modelInfo.mid);
			addChild(monsterAnimation);
		}

		public function get monsterinfo():MovieClip
		{
			if (_monsterinfo == null)
			{
				_monsterinfo = Load.getInstance("fla.uilibrary.MonsterInfo");
				if (_monsterinfo)
				{
					addChild(_monsterinfo);
					_monsterinfo.y = -model.h;
					updateView()
				}
			}
			return _monsterinfo;
		}

		private function updateView():void
		{
			monsterinfo.name_txt.text = enemyInfo.name;
			monsterinfo.hp_txt.text = monsterModel.HP + "/100";
			monsterinfo.hpline.hpvalue.width = monsterModel.HP / 100 * monsterinfo.hpline.back.width;
		}

		private function addListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event:Event):void
		{
			monsterAnimation.animationController.enterFrame();

			if (monsterinfo)
				monsterinfo.visible = true;
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
