import { WebSocketClient } from '../../network/WebSocketClient';
import { MessageType, ChatReq } from '../../network/Protocol';

export class Chat {
  private wsClient: WebSocketClient | null = null;

  constructor() {
    // Chat 类现在只负责发送消息，UI 由 Vue 组件处理
  }

  setWebSocketClient(wsClient: WebSocketClient): void {
    this.wsClient = wsClient;
  }

  sendMessage(message: string): void {
    if (!this.wsClient || !this.wsClient.isConnected()) {
      console.warn('WebSocket not connected, cannot send chat message');
      return;
    }

    const chatReq: ChatReq = {
      type: MessageType.CHAT_REQ,
      msg: message,
    };

    console.log('Chat.sendMessage: Sending chat request:', chatReq);
    this.wsClient.send(chatReq);
  }
}

