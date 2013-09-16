package communication.arpg
{
	import flash.utils.getTimer;
	
	import modules.GameDispatcher;
	import modules.GameEvent;
	import modules.chat.ChatEvent;
	import modules.chat.model.ChatModel;
	import modules.gamescene.GameSceneEvent;
	import modules.gamescene.data.MonsterModel;
	import modules.gamescene.data.PlayerModel;
	import modules.login.LoginEvent;
	
	import protobuf.ADD_MONSTER;
	import protobuf.ADD_PLAYER;
	import protobuf.ASPKG_ADD_MONSTER_NTF;
	import protobuf.ASPKG_ADD_PLAYER_NTF;
	import protobuf.ASPKG_CAST_SKILL_ACK;
	import protobuf.ASPKG_CAST_SKILL_NTF;
	import protobuf.ASPKG_CHAT_NTF;
	import protobuf.ASPKG_HP_UPDATE_NTF;
	import protobuf.ASPKG_LOGIN_ACK;
	import protobuf.ASPKG_MOVE_ACK;
	import protobuf.ASPKG_MOVE_NTF;
	import protobuf.ASPKG_MP_UPDATE_NTF;
	import protobuf.ASPKG_REMOVE_PLAYER_NTF;
	import protobuf.ASPKG_CAST_SKILL_ACK.E_CAST_SKILL_RESULT;
	import protobuf.ASPKG_LOGIN_ACK.E_LOGIN_RESULT;
	import protobuf.ASPKG_MOVE_ACK.E_MOVE_RESULT;

	public final class ARPGMsgProcessor
	{
		private static var _instance:ARPGMsgProcessor;

		public static function getInstance():ARPGMsgProcessor
		{
			if (_instance == null)
			{
				_instance = new ARPGMsgProcessor();
			}
			return _instance;
		}

		private function get dispatcher():GameDispatcher
		{
			return GameDispatcher.instance;
		}

		public function OnRecvLoginAck(pkg:ASPKG_LOGIN_ACK):void
		{
			switch (pkg.result)
			{
				case E_LOGIN_RESULT.SUCCEED:
					logger("登录成功.");
					dispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_SUCCEED, pkg));
					GlobalData.username = pkg.username;
					GlobalData.roleX = pkg.mapX;
					GlobalData.roleY = pkg.mapY;
					GlobalData.roleId = pkg.playerId;
					GlobalData.mapId = pkg.mapId;

					var playerModel:PlayerModel = new PlayerModel();
					playerModel.playerId = pkg.playerId;
					playerModel.username = pkg.username;
					playerModel.mapX = pkg.mapX;
					playerModel.mapY = pkg.mapY;
					playerModel.mapId = pkg.mapId;
					playerModel.HP = pkg.hP;
					playerModel.MP = pkg.mP;
					GameData.playerDic[playerModel.playerId] = playerModel;
					
					dispatcher.dispatchEvent(new ChatEvent(ChatEvent.CHAT_SHOW));

					dispatcher.dispatchEvent(new GameSceneEvent(GameSceneEvent.ADD_HERO, {mapX: pkg.mapX, mapY: pkg.mapY, clothing: pkg.clothing}));
					break;
				case E_LOGIN_RESULT.NO_REGISTER:
					logger("登录失败");
					dispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_FAIL, pkg));
					break;
				case E_LOGIN_RESULT.FAIL:
					logger("登录失败");
					dispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_FAIL, pkg));
					break;
				case E_LOGIN_RESULT.PASSWORD_ERROR:
					logger("登录失败");
					dispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_FAIL, pkg));
					break;
				default:
					logger("登录失败");
					dispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_FAIL, pkg));
					break;
			}
		}

		public function OnRecvMoveAck(pkg:ASPKG_MOVE_ACK):void
		{
			switch (pkg.result)
			{
				case E_MOVE_RESULT.SUCCEED:
//					logger("行走成功！");
					break;
				case E_MOVE_RESULT.FAIL:

					break;
			}
		}

		public function OnRecvMoveNtf(pkg:ASPKG_MOVE_NTF):void
		{
			if (pkg.playerId != GlobalData.roleId)
			{
				dispatcher.dispatchEvent(new GameSceneEvent(GameSceneEvent.PLAYER_WALK, {playerId: pkg.playerId, mapX: pkg.mapX, mapY: pkg.mapY}));
			}
		}

		public function OnRecvAddPlayerNtf(pkg:ASPKG_ADD_PLAYER_NTF):void
		{
			for each (var addPlayer:ADD_PLAYER in pkg.addPlayer)
			{
				if (addPlayer.playerId != GlobalData.roleId)
				{
					var playerModel:PlayerModel = new PlayerModel();
					playerModel.playerId = addPlayer.playerId;
					playerModel.username = addPlayer.username;
					playerModel.mapX = addPlayer.mapX;
					playerModel.mapY = addPlayer.mapY;
					playerModel.mapId = GlobalData.mapId;
					playerModel.HP = addPlayer.hP;
					playerModel.MP = addPlayer.mP;
					GameData.playerDic[playerModel.playerId] = playerModel;

					var data:Object = {playerId: addPlayer.playerId, username: addPlayer.username, mapX: addPlayer.mapX, mapY: addPlayer.mapY, clothing: addPlayer.clothing};
					dispatcher.dispatchEvent(new GameSceneEvent(GameSceneEvent.ADD_PLAYER, data));
				}
			}
		}

		public function OnRecvRemovePlayerNtf(pkg:ASPKG_REMOVE_PLAYER_NTF):void
		{
			GameData.playerDic[pkg.playerId] = null;
			delete GameData.playerDic[pkg.playerId];

			dispatcher.dispatchEvent(new GameSceneEvent(GameSceneEvent.REMOVE_PLAYER, {playerId: pkg.playerId}));
		}

		public function OnRecvCastSkillAck(pkg:ASPKG_CAST_SKILL_ACK):void
		{
			switch (pkg.result)
			{
				case E_CAST_SKILL_RESULT.SUCCEED:
					logger("释放技能成功");
					break;
				case E_CAST_SKILL_RESULT.FAIL:
					logger("释放技能失败");
					break;
			}
		}

		public function OnRecvCastSkillNtf(pkg:ASPKG_CAST_SKILL_NTF):void
		{
			var skillIndex:int = getTimer();
			//释放技能
			var data:Object = {skillIndex: skillIndex, playerId: pkg.playerId, type: pkg.type, skillId: pkg.skillId, mapX: pkg.mapX, mapY: pkg.mapY, targetId: pkg.targetId};
			GameData.castingSkillDic[skillIndex] = pkg;
			dispatcher.dispatchEvent(new GameSceneEvent(GameSceneEvent.CAST_SKILL, {skillIndex: skillIndex}));
		}

		public function OnRecvHPUpdateNtf(pkg:ASPKG_HP_UPDATE_NTF):void
		{
			var playerModel:PlayerModel = GameData.playerDic[pkg.playerId];
			playerModel.HP = pkg.hP;
			dispatcher.dispatchEvent(new ArpgMsgEvent(ARPGProto.ASID_HP_UPDATE_NTF, {playerId: pkg.playerId}));
			dispatcher.dispatchEvent(new GameEvent(GameEvent.HP_UPDATE_NTF, {playerId: pkg.playerId}));
		}

		public function OnRecvMPUpdateNtf(pkg:ASPKG_MP_UPDATE_NTF):void
		{
			var playerModel:PlayerModel = GameData.playerDic[pkg.playerId];
			playerModel.MP = pkg.mP;
			dispatcher.dispatchEvent(new ArpgMsgEvent(ARPGProto.ASID_MP_UPDATE_NTF, {playerId: pkg.playerId}));
		}

		public function OnRecvAddMonsterNtf(pkg:ASPKG_ADD_MONSTER_NTF):void
		{
			for each (var addMonster:ADD_MONSTER in pkg.addMonster)
			{
				if (addMonster.playerId != GlobalData.roleId)
				{
					var monsterModel:MonsterModel = new MonsterModel();
					monsterModel.monsterId = addMonster.monsterId;
					monsterModel.typeId = addMonster.typeId;
					monsterModel.mapX = addMonster.mapX;
					monsterModel.mapY = addMonster.mapY;
					monsterModel.HP = addMonster.hP;
					GameData.monsterDic[monsterModel.monsterId] = monsterModel;

					var data:Object = monsterModel;
					dispatcher.dispatchEvent(new GameSceneEvent(GameSceneEvent.ADD_MONSTER, data));
				}
			}
		}
		
		public function OnRecvChatNtf(pkg:ASPKG_CHAT_NTF):void
		{
			var chatModel:ChatModel = new ChatModel();
			chatModel.playerId = pkg.playerId;
			chatModel.username = pkg.username;
			chatModel.msg = pkg.msg;
			dispatcher.dispatchEvent(new ChatEvent(ChatEvent.SPEAK,chatModel));
		}
	}
}
