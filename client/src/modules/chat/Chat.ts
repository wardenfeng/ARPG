import { ChatUI } from './ChatUI';
import { WebSocketClient } from '../../network/WebSocketClient';
import { MessageType, ChatReq, ChatNtf } from '../../network/Protocol';
import { EventBus } from '../../core/EventBus';

export class Chat {
  private chatUI: ChatUI;
  private wsClient: WebSocketClient | null = null;
  private eventBus: EventBus;

  constructor(eventBus: EventBus) {
    this.eventBus = eventBus;
    this.chatUI = new ChatUI();
    this.setupUI();
  }

  private setupUI(): void {
    this.chatUI.setOnSend((message) => {
      this.sendMessage(message);
    });

    // Listen for chat messages
    this.eventBus.on('message:CHAT_NTF', (message: ChatNtf) => {
      this.handleChatMessage(message);
    });
  }

  setWebSocketClient(wsClient: WebSocketClient): void {
    this.wsClient = wsClient;
  }

  show(): void {
    this.chatUI.show();
  }

  hide(): void {
    this.chatUI.hide();
  }

  private sendMessage(message: string): void {
    if (!this.wsClient || !this.wsClient.isConnected()) {
      console.warn('WebSocket not connected');
      return;
    }

    const chatReq: ChatReq = {
      type: MessageType.CHAT_REQ,
      msg: message,
    };

    this.wsClient.send(chatReq);
  }

  private handleChatMessage(message: ChatNtf): void {
    this.chatUI.addMessage(message.username, message.msg);
  }
}

