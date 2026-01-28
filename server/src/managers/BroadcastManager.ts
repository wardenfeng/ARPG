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
    console.log('BroadcastManager.chat: Broadcasting to map', mapId, 'excluding player', excludePlayerId);
    this.broadcastToMap(mapId, ntf, excludePlayerId);
  }

  broadcastToMap(mapId: number, message: GameMessage, excludePlayerId?: number): void {
    const players = this.playerManager.getPlayersInMap(mapId);
    const clients = this.wsServer.getAllClients();
    
    console.log(`BroadcastManager.broadcastToMap: Map ${mapId}, ${players.length} players, ${clients.length} clients, excludePlayerId: ${excludePlayerId}`);
    
    let sentCount = 0;
    let skippedCount = 0;
    
    for (const ws of clients) {
      const clientId = this.wsServer.getClientId(ws);
      if (!clientId) {
        console.warn('BroadcastManager: Client has no ID');
        continue;
      }
      
      const player = this.playerManager.getPlayerByClientId(clientId);
      if (!player) {
        console.warn(`BroadcastManager: No player found for client ID ${clientId}`);
        skippedCount++;
        continue;
      }
      
      if (player.mapId !== mapId) {
        console.log(`BroadcastManager: Player ${player.username} is not in map ${mapId} (in map ${player.mapId})`);
        skippedCount++;
        continue;
      }
      
      if (excludePlayerId !== undefined && player.id === excludePlayerId) {
        console.log(`BroadcastManager: Excluding player ${player.username} (ID: ${player.id})`);
        skippedCount++;
        continue;
      }
      
      if (ws.readyState !== 1) { // WebSocket.OPEN = 1
        console.warn(`BroadcastManager: WebSocket for player ${player.username} is not open (state: ${ws.readyState})`);
        skippedCount++;
        continue;
      }
      
      try {
        this.wsServer.sendToClient(ws, message);
        sentCount++;
        console.log(`BroadcastManager: Sent message to player ${player.username} (ID: ${player.id}, Client ID: ${clientId})`);
      } catch (error) {
        console.error(`BroadcastManager: Error sending to player ${player.username}:`, error);
        skippedCount++;
      }
    }
    
    console.log(`BroadcastManager: Sent message to ${sentCount} players, skipped ${skippedCount} clients`);
  }
}

