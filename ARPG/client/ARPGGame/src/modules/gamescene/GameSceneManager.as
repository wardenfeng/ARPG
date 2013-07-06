package modules.gamescene
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import animation.Animation;
	import animation.AnimationEvent;
	import animation.ISceneItem;
	import animation.animal.Monster;
	import animation.animal.Player;
	import animation.animationtypes.EffectsAnimation;
	import animation.animationtypes.MonsterAnimation;
	import animation.configs.ActionType;
	import animation.configs.Direction;

	import communication.arpg.ArpgMsgEvent;

	import modules.ModulesManager;
	import modules.findpath.FindpathEvent;
	import modules.findpath.MapTileModel;
	import modules.gamescene.data.PlayerModel;
	import modules.moveaction.MoveActionController;
	import modules.moveaction.MoveActionEvent;

	import protobuf.ASPKG_CAST_SKILL_NTF;
	import protobuf.E_ATTACK_TYPE;
	import protobuf.E_OBJECT_TYPE;
	import protobuf.SKILL_HARM;

	/**
	 * 操作真实地图
	 * @author 风之守望者 2012-7-1
	 */
	public class GameSceneManager extends ModulesManager
	{
		/** 场景地图配置 */
		private var sceneMapConfig:GameSceneConfig;

		/** 地图层 */
		private var gameSceneBackground:GameSceneBackground;

		/** 路径层 */
		private var pathlayer:Shape;

		private var npcManager:NPCManager;

		public function get hero():Player
		{
			return GlobalData.hero;
		}

		private function get sceneLayer():Sprite
		{
			return UIAllRefer.sceneLayer;
		}

		public function GameSceneManager()
		{
			//初始化地图
			gameSceneBackground = new GameSceneBackground();
			sceneLayer.addChildAt(gameSceneBackground, 0);

			pathlayer = new Shape();
			pathlayer.name = "pathlayer";
			sceneLayer.addChild(pathlayer);

			GameScene.sceneItemLayer = new Sprite();
			GameScene.sceneItemLayer.name = "GameScene.sceneItemLayer";
			sceneLayer.addChild(GameScene.sceneItemLayer);
			GameScene.sceneItemLayer.mouseEnabled = false;

			npcManager = new NPCManager(GameScene.sceneItemLayer);

			if (GlobalData.isShowGird)
				drawGird();

			addListeners();
		}

		private function mapShowCompleted(event:Event):void
		{
			trace("地图显示完成");

			dispatcher.dispatchEvent(new GameSceneEvent(GameSceneEvent.SCENE_COMPLETED));
		}

		private function addListeners():void
		{
			dispatcher.addEventListener(GameSceneEvent.ADD_HERO, onAddHero);
			dispatcher.addEventListener(GameSceneEvent.ADD_PLAYER, onAddPlayer);
			dispatcher.addEventListener(GameSceneEvent.REMOVE_PLAYER, onRemovePlayer);
			dispatcher.addEventListener(GameSceneEvent.PLAYER_WALK, onPlayerWalk);
			dispatcher.addEventListener(GameSceneEvent.CAST_SKILL, onCastSkill);
			dispatcher.addEventListener(GameSceneEvent.GET_SKILL_TARGET, onGetSkillTarget);

			dispatcher.addEventListener(GameSceneEvent.ADD_MONSTER, onAddMonster);
		}

		private function onAddHero(event:GameSceneEvent):void
		{
			//加载地图配置
			sceneMapConfig = new GameSceneConfig(GlobalData.mapId);

			var animal:Player = new Player();
			animal.name = "hero" + GlobalData.roleId;
			animal.mapX = event.data.mapX;
			animal.mapY = event.data.mapY;
			animal.clothing = event.data.clothing;
			animal.playerId = GlobalData.roleId;
			GlobalData.hero = animal;
			hero.mouseEnabled = false;
			hero.mouseChildren = false;

			addPlayer(animal);

			sceneLayer.addEventListener(MouseEvent.CLICK, onSceneClick);

			UIAllRefer.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			trace("添加人物完成");
		}

		private function onEnterFrame(event:Event):void
		{
			if (GameSceneConfig.mapData == null)
				return;

			setHeroCenter();

			for each (var ani:Animation in GameScene.skillEffects)
			{
				ani.animationController.enterFrame();
			}
		}

		private function onAddPlayer(event:GameSceneEvent):void
		{
			var animal:Player = new Player();
			animal.name = "player" + event.data.playerId;
			animal.clothing = event.data.clothing;
			animal.mapX = event.data.mapX;
			animal.mapY = event.data.mapY;
			animal.playerId = event.data.playerId;

			addPlayer(animal);
		}

		private function onRemovePlayer(event:GameSceneEvent):void
		{
			var animal:Player = GameScene.playerDic[event.data.playerId];
			removePlayer(animal);
		}

		private function addPlayer(player:Player):void
		{
			GameScene.sceneItemLayer.addChild(player);
			GameScene.playerDic[player.playerId] = player;
			GameScene.playerList.push(player);
			GameScene.sceneItems.push(player);
		}

		private function removePlayer(animal:Player):void
		{
			if (animal && animal.parent)
			{
				animal.parent.removeChild(animal);
			}

			var index:int;
			index = GameScene.playerList.indexOf(animal);
			if (index != -1)
			{
				GameScene.playerList.splice(index, 1);
			}
			index = GameScene.sceneItems.indexOf(animal);
			if (index != -1)
			{
				GameScene.sceneItems.splice(index, 1);
			}
		}

		private function onPlayerWalk(event:GameSceneEvent):void
		{
			var animal:Player = GameScene.playerDic[event.data.playerId];
			animal.destination = new Point(event.data.mapX, event.data.mapY);
		}

		private function onGetSkillTarget(event:GameSceneEvent):void
		{
			//获取地图坐标
			var mapPoint:Point = MapTileModel.girdCoordinate(sceneLayer.mouseX, sceneLayer.mouseY);
			event.data.mapX = mapPoint.x;
			event.data.mapY = mapPoint.y;

			//获取攻击目标编号
			var targetAnimals:Array = [];

			var stg:Stage = GameScene.sceneItemLayer.stage;
			var p:Point = new Point(stg.mouseX, stg.mouseY);
			stg.areInaccessibleObjectsUnderPoint(p)

			var underObjects:Array = stg.getObjectsUnderPoint(p);
			for each (var child:DisplayObject in underObjects)
			{
				var chain:Array = new Array(child);
				var par:DisplayObjectContainer = child.parent;
				while (par)
				{
					chain.unshift(par);
					par = par.parent;
				}
				var len:uint = chain.length;
				for (var i:uint = 0; i < len; i++)
				{
					var obj:DisplayObject = chain[i];
					var animal:Player = obj as Player;
					if (animal)
					{
						if (animal.playerId != GlobalData.roleId)
						{
							if (targetAnimals.indexOf(animal.playerId) == -1)
								targetAnimals.push(animal.playerId);
						}
					}

				}
			}
			event.data.targetAnimals = targetAnimals;
		}

		private function onCastSkill(event:GameSceneEvent):void
		{
			var skillIndex:int = event.data.skillIndex;
			var castSkillNtf:ASPKG_CAST_SKILL_NTF = GameData.castingSkillDic[skillIndex];

			var animal:Player = GameScene.playerDic[castSkillNtf.playerId];

			if (castSkillNtf.playerId == GlobalData.roleId)
			{
				MoveActionController.findPathArr = null;
			}

			var targetPoint:Point = new Point();
			switch (castSkillNtf.type)
			{
				case E_ATTACK_TYPE.POINT:
					targetPoint.x = castSkillNtf.mapX;
					targetPoint.y = castSkillNtf.mapY;
					break;
				case E_ATTACK_TYPE.PLALER:
					var targetPlayer:Player = GameScene.playerDic[castSkillNtf.targetId];
					if (targetPlayer)
					{
						targetPoint.x = targetPlayer.mapX;
						targetPoint.y = targetPlayer.mapY;
					}
					break;

			}
			var animalDirPoint:Point = new Point(targetPoint.x - animal.mapX, targetPoint.y - animal.mapY);
			var animalDir:int = Direction.getDirection(animalDirPoint);

			animal.action = ActionType.CASTSKILL;
			animal.direction = animalDir;

			var sftxl:EffectsAnimation = new EffectsAnimation("sftxl");
			sftxl.skillIndex = skillIndex;
			sftxl.name = "sftxl";
			animal.addChild(sftxl);
			sftxl.addEventListener(AnimationEvent.LOOPED, onSFTXLooped);

			addEffects(sftxl);
		}

		private function onSFTXLooped(event:Event):void
		{
			var ani:EffectsAnimation = event.currentTarget as EffectsAnimation;
			removeEffects(ani);

			var castSkillNtf:ASPKG_CAST_SKILL_NTF = GameData.castingSkillDic[ani.skillIndex];

			if (castSkillNtf)
			{
				var floorPoint:Point = new Point();
				switch (castSkillNtf.type)
				{
					case E_ATTACK_TYPE.POINT:
						floorPoint = MapTileModel.realCoordinate(castSkillNtf.mapX, castSkillNtf.mapY);
						break;
					case E_ATTACK_TYPE.PLALER:
						var targetPlayer:Player = GameScene.playerDic[castSkillNtf.targetId];
						if (targetPlayer)
						{
							floorPoint.x = targetPlayer.floorX;
							floorPoint.y = targetPlayer.floorY;
						}
						break;

				}

				castSkillNtf.skillId; //通过skillid获得skillname
				var skillName:String = "lds";

				var lds:EffectsAnimation = new EffectsAnimation(skillName);
				lds.skillIndex = ani.skillIndex;
				lds.name = skillName;
				lds.floorPoint = floorPoint;
				lds.addEventListener(AnimationEvent.LOOPED, onLooped);

				GameScene.sceneItemLayer.addChild(lds);
				addEffects(lds);
			}
		}

		private function onLooped(event:Event):void
		{
			var ani:EffectsAnimation = event.currentTarget as EffectsAnimation;
			removeEffects(ani);

			dispatcher.dispatchEvent(new GameSceneEvent(GameSceneEvent.CAST_SKILL_END, {skillIndex: ani.skillIndex}));

			var castSkillNtf:ASPKG_CAST_SKILL_NTF = GameData.castingSkillDic[ani.skillIndex];
			for each (var skillHarm:SKILL_HARM in castSkillNtf.skillHarms)
			{
				switch (skillHarm.type)
				{
					case E_OBJECT_TYPE.PLAYER:
						var playerModel:PlayerModel = GameData.playerDic[skillHarm.targetId];
						playerModel.HP = playerModel.HP + skillHarm.harmValue;
						dispatcher.dispatchEvent(new ArpgMsgEvent(ARPGProto.ASID_HP_UPDATE_NTF, {playerId: skillHarm.targetId}));
						break;
				}
			}


		}

		private function addEffects(effect:EffectsAnimation):void
		{
			GameScene.skillEffects.push(effect);
			GameScene.sceneItems.push(effect);
		}

		private function removeEffects(effect:EffectsAnimation):void
		{
			if (effect.parent)
				effect.parent.removeChild(effect);

			var index:int;
			index = GameScene.skillEffects.indexOf(effect);
			if (index != -1)
				GameScene.skillEffects.splice(index, 1);
			index = GameScene.sceneItems.indexOf(effect);
			if (index != -1)
				GameScene.sceneItems.splice(index, 1);
		}

		private function onAddMonster(event:GameSceneEvent):void
		{
			var animal:Monster = new Monster();
			animal.monsterId = event.data.monsterId;
			addMonster(animal);
		}

		private function addMonster(monster:Monster):void
		{
			GameScene.sceneItemLayer.addChild(monster);
			GameScene.monsterDic[monster.monsterId] = monster;
			GameScene.monsterList.push(monster);
			GameScene.sceneItems.push(monster);
		}

		/**
		 * 点击场景
		 */
		private function onSceneClick(event:MouseEvent):void
		{
			if (event.target != sceneLayer)
				return;
			//计算玩家所在的格子坐标
			var startPoint:Point = MapTileModel.girdCoordinate(hero.x, hero.y);
			//计算点击位置的格子坐标
			var endPoint:Point = MapTileModel.girdCoordinate(event.localX, event.localY);
			//trace("起点", startPoint, "	终点", endPoint);

			var findpathEvent:FindpathEvent = new FindpathEvent(FindpathEvent.FIND_PATH, startPoint.x, startPoint.y, endPoint.x, endPoint.y);
			//抛出事件获取路径
			dispatcher.dispatchEvent(findpathEvent);
			var path:Array = findpathEvent.path;
			//trace("A*路径", path);

			if (path)
			{
//				drawPath(path);

				dispatcher.dispatchEvent(new MoveActionEvent(MoveActionEvent.HERO_START_MOVE, path));
			}
			else
			{
				trace("无法找到路径");
			}
		}

		/**
		 * 绘制路径
		 * @param path 路径数据
		 */
		private function drawPath(path:Array):void
		{
			pathlayer.graphics.clear();
			if (path == null)
				return;
			pathlayer.graphics.beginFill(0xff0000);
			for (var i:int = 0; i < path.length; i++)
			{
				var realPoint:Point = MapTileModel.realCoordinate(path[i][0], path[i][1]);
				pathlayer.graphics.drawCircle(realPoint.x, realPoint.y, GameSceneConfig.TILE_HEIGHT / 2);
			}
			pathlayer.graphics.endFill();
		}

		/**
		 * 绘制网格
		 */
		private function drawGird():void
		{
			var shape:Shape = new Shape();
			shape.name = "gridShap";
			sceneLayer.addChild(shape);

			var startx:Number = -GameSceneConfig.TILE_WIDTH / 2;
			var starty:Number = -GameSceneConfig.TILE_HEIGHT / 2;
			shape.graphics.lineStyle(2, 0x00ff00);
			while (startx < GameSceneConfig.mapWidth + GameSceneConfig.TILE_WIDTH / 2)
			{
				shape.graphics.moveTo(startx, -GameSceneConfig.TILE_HEIGHT / 2);
				shape.graphics.lineTo(startx, GameSceneConfig.mapHeight + GameSceneConfig.TILE_HEIGHT / 2);
				startx += GameSceneConfig.TILE_WIDTH;
			}
			while (starty < GameSceneConfig.mapHeight + GameSceneConfig.TILE_HEIGHT / 2)
			{
				shape.graphics.moveTo(-GameSceneConfig.TILE_WIDTH / 2, starty);
				shape.graphics.lineTo(GameSceneConfig.mapWidth + GameSceneConfig.TILE_WIDTH / 2, starty);
				starty += GameSceneConfig.TILE_HEIGHT;
			}
		}

		/**
		 * 设置英雄为中心(地图卷动)
		 */
		private function setHeroCenter():void
		{
			//移动场景
			sceneLayer.x = int(UIAllRefer.stage.stageWidth / 2 - hero.x);
			sceneLayer.y = int(UIAllRefer.stage.stageHeight / 2 - hero.y);

			//设置场景移动边界(避免看到黑边)
			if (sceneLayer.x > 0)
			{
				sceneLayer.x = 0;
			}
			if (sceneLayer.y > 0)
			{
				sceneLayer.y = 0;
			}
			if (sceneLayer.x < UIAllRefer.stage.stageWidth - GameSceneConfig.mapWidth)
			{
				sceneLayer.x = UIAllRefer.stage.stageWidth - GameSceneConfig.mapWidth;
			}
			if (sceneLayer.y < UIAllRefer.stage.stageHeight - GameSceneConfig.mapHeight)
			{
				sceneLayer.y = UIAllRefer.stage.stageHeight - GameSceneConfig.mapHeight;
			}
			var showArea:Rectangle = new Rectangle(-sceneLayer.x, -sceneLayer.y, UIAllRefer.stage.stageWidth, UIAllRefer.stage.stageHeight);
			gameSceneBackground.showMap(GlobalData.mapId, showArea);

			//深度排序
			depthSort();
			//透明检测
			checkTransparent();

		}

		private function depthSort():void
		{
			GameScene.sceneItems.sortOn("floorY");

			for (var i:int = 0; i < GameScene.sceneItems.length; i++)
			{
				var sceneItem:ISceneItem = GameScene.sceneItems[i];
				var animal:DisplayObject = sceneItem as DisplayObject;
				animal.parent.addChild(animal);
			}
		}

		private function checkTransparent():void
		{
			var mapData:Array = GameSceneConfig.mapData;
			for (var i:int = 0; i < GameScene.playerList.length; i++)
			{
				var animal:Player = GameScene.playerList[i];

				if (mapData[animal.mapX][animal.mapY] == MapTileModel.PATH_TRANSPARENT)
				{
					animal.alpha = 0.6;
				}
				else
				{
					animal.alpha = 1.0;
				}
			}

		}
	}
}
