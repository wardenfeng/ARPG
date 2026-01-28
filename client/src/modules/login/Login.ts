import { WebSocketClient } from '../../network/WebSocketClient';
import { LoginAck, LoginResult } from '../../network/Protocol';
import { EventBus } from '../../core/EventBus';

export class Login {
  private eventBus: EventBus;
  private onLoginSuccessCallback?: (data: LoginAck) => void;

  constructor(eventBus: EventBus) {
    this.eventBus = eventBus;
  }

  setWebSocketClient(_wsClient: WebSocketClient): void {
    // WebSocket client is set but not directly used here
    // Login logic is handled through EventBus
    
    // Listen for login response (MessageHandler emits both 'message:LOGIN_ACK' and 'login:result')
    this.eventBus.on('message:LOGIN_ACK', (message: LoginAck) => {
      this.handleLoginResponse(message);
    });
    this.eventBus.on('login:result', (message: LoginAck) => {
      this.handleLoginResponse(message);
    });
  }

  setOnLoginSuccess(callback: (data: LoginAck) => void): void {
    this.onLoginSuccessCallback = callback;
  }

  private handleLoginResponse(message: LoginAck): void {
    if (message.result === LoginResult.SUCCEED) {
      if (this.onLoginSuccessCallback) {
        this.onLoginSuccessCallback(message);
      }
    } else {
      alert(`Login failed: ${message.result}`);
    }
  }
}

