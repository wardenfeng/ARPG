import { WebSocket } from 'ws';
import { ChatReq, ChatNtf, MessageType } from '../types/Protocol';
import { PlayerManager } from '../managers/PlayerManager';
import { BroadcastManager } from '../managers/BroadcastManager';
import { WebSocketServer } from '../websocket/WebSocketServer';

export class ChatHandler {
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

  handle(ws: WebSocket, message: ChatReq): void {
    const clientId = this.wsServer.getClientId(ws);
    if (!clientId) {
      return;
    }

    const player = this.playerManager.getPlayerByClientId(clientId);
    if (!player) {
      return;
    }

    // Broadcast chat message
    const ntf: ChatNtf = {
      type: MessageType.CHAT_NTF,
      playerId: player.id,
      username: player.username,
      msg: message.msg,
    };
    this.broadcastManager.chat(player.mapId, ntf, player.id);
  }
}

