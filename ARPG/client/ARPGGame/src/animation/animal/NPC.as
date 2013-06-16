package animation.animal
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	import animation.ISceneItem;
	import animation.animationtypes.NPCAnimation;

	import modules.gamescene.GameSceneConfig;
	import modules.load.Load;

	/**
	 *
	 * @author warden feng 2013-6-16
	 */
	public class NPC extends Sprite implements ISceneItem
	{
		/** npc信息 */
		private var _npcinfo:MovieClip;

		private var _mapX:int;

		private var _mapY:int;

		private var npcAnimation:NPCAnimation;

		private var NPCName:Object;

		public var npcId:String;

		private var modelId:String;

		private var modelInfo:Object;

		public function NPC(npcId:String)
		{
			this.npcId = npcId;

			NPCName = GameData.NPCNameDic[npcId];

			modelId = NPCName.modelId;

			modelInfo = GameData.modelInfoDic[modelId];

			npcAnimation = new NPCAnimation(modelInfo.mid);
			addChild(npcAnimation);

			addListeners();
		}

		public function get npcinfo():MovieClip
		{
			if (_npcinfo == null)
			{
				_npcinfo = Load.getInstance("fla.uilibrary.NPCInfo");
				if (_npcinfo)
				{
					addChild(_npcinfo);
					var npcObj:Object = GameData.NPCNameDic[npcId];
					_npcinfo.name_txt.text = npcObj.name;

					var model:Object = GameData.modelDic["resources/npc/" + modelInfo.mid + ".swf"];
					_npcinfo.y = -model.h - 10;

				}
			}
			return _npcinfo;
		}

		private function addListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event:Event):void
		{
			npcAnimation.animationController.enterFrame();

			if (npcinfo)
				npcinfo.visible = true;
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
