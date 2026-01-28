import { WebSocket } from 'ws';
import { CastSkillReq, CastSkillAck, CastSkillNtf, MessageType, CastSkillResult, AttackType, SkillHarm, ObjectType } from '../types/Protocol';
import { PlayerManager } from '../managers/PlayerManager';
import { BroadcastManager } from '../managers/BroadcastManager';
import { SkillManager } from '../managers/SkillManager';
import { WebSocketServer } from '../websocket/WebSocketServer';

export class SkillHandler {
  private playerManager: PlayerManager;
  private broadcastManager: BroadcastManager;
  private skillManager: SkillManager;
  private wsServer: WebSocketServer;

  constructor(
    playerManager: PlayerManager,
    broadcastManager: BroadcastManager,
    skillManager: SkillManager,
    wsServer: WebSocketServer
  ) {
    this.playerManager = playerManager;
    this.broadcastManager = broadcastManager;
    this.skillManager = skillManager;
    this.wsServer = wsServer;
  }

  handle(ws: WebSocket, message: CastSkillReq): void {
    const clientId = this.wsServer.getClientId(ws);
    if (!clientId) {
      return;
    }

    const player = this.playerManager.getPlayerByClientId(clientId);
    if (!player) {
      return;
    }

    // Check MP
    if (player.mp < 5) {
      const ack: CastSkillAck = {
        type: MessageType.CAST_SKILL_ACK,
        result: CastSkillResult.FAIL,
      };
      this.wsServer.sendToClient(ws, ack);
      return;
    }

    // Process skill
    const skillHarms = this.skillManager.castSkill(
      player,
      message.skillId,
      message.attackType,
      message.targetId,
      message.mapX,
      message.mapY
    );

    // Send ACK
    const ack: CastSkillAck = {
      type: MessageType.CAST_SKILL_ACK,
      result: CastSkillResult.SUCCEED,
    };
    this.wsServer.sendToClient(ws, ack);

    // Broadcast skill cast
    const ntf: CastSkillNtf = {
      type: MessageType.CAST_SKILL_NTF,
      playerId: player.id,
      skillId: message.skillId,
      attackType: message.attackType,
      targetId: message.targetId,
      mapX: message.mapX,
      mapY: message.mapY,
      skillHarms,
    };
    this.broadcastManager.castSkill(player.mapId, ntf, player.id);
  }
}

