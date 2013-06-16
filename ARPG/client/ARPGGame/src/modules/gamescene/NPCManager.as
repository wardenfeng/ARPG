package modules.gamescene
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import animation.animal.NPC;
	
	import modules.ModulesManager;

	/**
	 *
	 * @author warden feng 2013-6-16
	 */
	public class NPCManager extends ModulesManager
	{
		private var sceneItemLayer:Sprite;

		public function NPCManager(sceneItemLayer:Sprite)
		{
			this.sceneItemLayer = sceneItemLayer;
			addListeners();
		}

		private function addListeners():void
		{
			dispatcher.addEventListener(GameSceneEvent.SCENE_CONFIG_COMPLETED, configLoadCompleted);
		}

		private function configLoadCompleted(event:GameSceneEvent):void
		{
			showNPC();
		}

		private function showNPC():void
		{
			var NPCNameDic:Dictionary = GameData.NPCNameDic;
			var modelDic:Dictionary = GameData.modelDic;

			for(var npcId:String in NPCNameDic)
			{
				var npcObj:Object = NPCNameDic[npcId];
				if (npcObj.mapId == GlobalData.mapId)
				{
					var npc:NPC = new NPC(npcId);
					
					npc.mapX = npcObj.x;
					npc.mapY = npcObj.y;

					addNPC(npc);
				}
			}
		}

		private function addNPC(npc:NPC):void
		{
			sceneItemLayer.addChild(npc);
			GameScene.npcList.push(npc);
			GameScene.sceneItems.push(npc);
		}

	}
}
