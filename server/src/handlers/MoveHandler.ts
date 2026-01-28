import { WebSocket } from 'ws';
import { MoveReq, MoveAck, MoveNtf, MessageType, MoveResult } from '../types/Protocol';
import { PlayerManager } from '../managers/PlayerManager';
import { BroadcastManager } from '../managers/BroadcastManager';
import { WebSocketServer } from '../websocket/WebSocketServer';

export class MoveHandler {
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

  handle(ws: WebSocket, message: MoveReq): void {
    const clientId = this.wsServer.getClientId(ws);
    if (!clientId) {
      return;
    }

    const player = this.playerManager.getPlayerByClientId(clientId);
    if (!player) {
      return;
    }

    // Update player position
    player.mapX = message.mapX;
    player.mapY = message.mapY;

    // Send ACK
    const ack: MoveAck = {
      type: MessageType.MOVE_ACK,
      result: MoveResult.SUCCEED,
    };
    this.wsServer.sendToClient(ws, ack);

    // Broadcast move to other players in the same map
    this.broadcastManager.move(player.mapId, player.id, player.mapX, player.mapY, player.id);
  }
}

