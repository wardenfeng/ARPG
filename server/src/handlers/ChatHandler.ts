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
    console.log('ChatHandler.handle: Received chat request:', message);
    
    const clientId = this.wsServer.getClientId(ws);
    if (!clientId) {
      console.warn('ChatHandler: No client ID found');
      return;
    }

    const player = this.playerManager.getPlayerByClientId(clientId);
    if (!player) {
      console.warn('ChatHandler: No player found for client ID:', clientId);
      return;
    }

    console.log('ChatHandler: Broadcasting chat message from player:', player.username, 'message:', message.msg);

    // Broadcast chat message (包括发送者自己，所以不排除)
    const ntf: ChatNtf = {
      type: MessageType.CHAT_NTF,
      playerId: player.id,
      username: player.username,
      msg: message.msg,
    };
    // 不排除发送者，让所有玩家（包括发送者）都能看到消息
    this.broadcastManager.chat(player.mapId, ntf);
    console.log('ChatHandler: Chat message broadcasted');
  }
}

