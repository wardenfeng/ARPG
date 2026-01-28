import { GameMessage } from '../types/Protocol';
import { Player } from '../models/Player';
import { PlayerManager } from './PlayerManager';
import { WebSocketServer } from '../websocket/WebSocketServer';
import { AddPlayerNtf, RemovePlayerNtf, MoveNtf, CastSkillNtf, ChatNtf, MessageType } from '../types/Protocol';

export class BroadcastManager {
  private playerManager: PlayerManager;
  private wsServer: WebSocketServer;

  constructor(playerManager: PlayerManager, wsServer: WebSocketServer) {
    this.playerManager = playerManager;
    this.wsServer = wsServer;
  }

  addPlayer(mapId: number, player: Player, excludePlayerId?: number): void {
    const ntf: AddPlayerNtf = {
      type: MessageType.ADD_PLAYER_NTF,
      addPlayer: [{
        playerId: player.id,
        mapX: player.mapX,
        mapY: player.mapY,
        username: player.username,
        clothing: player.clothing,
        HP: player.hp,
        MP: player.mp,
      }],
    };
    this.broadcastToMap(mapId, ntf, excludePlayerId);
  }

  removePlayer(mapId: number, playerId: number): void {
    const ntf: RemovePlayerNtf = {
      type: MessageType.REMOVE_PLAYER_NTF,
      playerId,
    };
    this.broadcastToMap(mapId, ntf);
  }

  move(mapId: number, playerId: number, mapX: number, mapY: number, excludePlayerId?: number): void {
    const ntf: MoveNtf = {
      type: MessageType.MOVE_NTF,
      playerId,
      mapX,
      mapY,
    };
    this.broadcastToMap(mapId, ntf, excludePlayerId);
  }

  castSkill(mapId: number, ntf: CastSkillNtf, excludePlayerId?: number): void {
    this.broadcastToMap(mapId, ntf, excludePlayerId);
  }

  chat(mapId: number, ntf: ChatNtf, excludePlayerId?: number): void {
    this.broadcastToMap(mapId, ntf, excludePlayerId);
  }

  broadcastToMap(mapId: number, message: GameMessage, excludePlayerId?: number): void {
    const players = this.playerManager.getPlayersInMap(mapId);
    const clients = this.wsServer.getAllClients();
    
    for (const ws of clients) {
      const clientId = this.wsServer.getClientId(ws);
      if (!clientId) continue;
      
      const player = this.playerManager.getPlayerByClientId(clientId);
      if (player && player.mapId === mapId && player.id !== excludePlayerId) {
        this.wsServer.sendToClient(ws, message);
      }
    }
  }
}

