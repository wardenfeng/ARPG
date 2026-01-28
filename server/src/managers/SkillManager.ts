import { Player } from '../models/Player';
import { AttackType, SkillHarm, ObjectType } from '../types/Protocol';
import { PlayerManager } from './PlayerManager';
import { HPUpdateNtf, MPUpdateNtf, MessageType } from '../types/Protocol';
import { WebSocketServer } from '../websocket/WebSocketServer';
import { BroadcastManager } from './BroadcastManager';

export class SkillManager {
  private playerManager: PlayerManager;
  private broadcastManager: BroadcastManager;
  private wsServer: WebSocketServer;

  constructor(
    playerManager: PlayerManager,
    broadcastManager: BroadcastManager,
    wsServer: WebSocketServer
  ) {
    this.playerManager = playerManager;
    this.broadcastManager = broadcastManager;
    this.wsServer = wsServer;
  }

  castSkill(
    attacker: Player,
    skillId: number,
    attackType: AttackType,
    targetId?: number,
    mapX?: number,
    mapY?: number
  ): SkillHarm[] {
    // Consume MP
    attacker.mp = Math.max(0, attacker.mp - 5);
    
    // Broadcast MP update
    const mpNtf: MPUpdateNtf = {
      type: MessageType.MP_UPDATE_NTF,
      playerId: attacker.id,
      MP: attacker.mp,
    };
    this.broadcastManager.broadcastToMap(attacker.mapId, mpNtf, attacker.id);

    const skillHarms: SkillHarm[] = [];

    if (attackType === AttackType.PLAYER && targetId) {
      const target = this.playerManager.getPlayerByPlayerId(targetId);
      if (target && target.mapId === attacker.mapId) {
        // Calculate damage
        const harmValue = Math.max(-10, -target.hp);
        target.hp = Math.max(0, target.hp + harmValue);

        skillHarms.push({
          type: ObjectType.PLAYER,
          targetId: target.id,
          harmValue,
        });

        // Broadcast HP update
        const hpNtf: HPUpdateNtf = {
          type: MessageType.HP_UPDATE_NTF,
          playerId: target.id,
          HP: target.hp,
        };
        this.broadcastManager.broadcastToMap(target.mapId, hpNtf);
      }
    }

    return skillHarms;
  }
}

