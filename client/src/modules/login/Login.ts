import { LoginUI } from './LoginUI';
import { WebSocketClient } from '../../network/WebSocketClient';
import { MessageType, LoginReq, LoginAck, LoginResult } from '../../network/Protocol';
import { EventBus } from '../../core/EventBus';

export class Login {
  private loginUI: LoginUI;
  private wsClient: WebSocketClient | null = null;
  private eventBus: EventBus;
  private onLoginSuccessCallback?: (data: LoginAck) => void;

  constructor(eventBus: EventBus) {
    this.eventBus = eventBus;
    this.loginUI = new LoginUI();
    this.setupUI();
  }

  private setupUI(): void {
    this.loginUI.setOnLogin((account, password) => {
      this.handleLogin(account, password);
    });
  }

  show(): void {
    this.loginUI.show();
  }

  hide(): void {
    this.loginUI.hide();
  }

  setWebSocketClient(wsClient: WebSocketClient): void {
    this.wsClient = wsClient;
    
    // Listen for login response
    this.eventBus.on('message:LOGIN_ACK', (message: LoginAck) => {
      this.handleLoginResponse(message);
    });
  }

  setOnLoginSuccess(callback: (data: LoginAck) => void): void {
    this.onLoginSuccessCallback = callback;
  }

  private async handleLogin(account: string, password: string): Promise<void> {
    if (!this.wsClient) {
      console.error('WebSocket client not initialized');
      return;
    }

    if (!this.wsClient.isConnected()) {
      try {
        await this.wsClient.connect();
      } catch (error) {
        console.error('Failed to connect:', error);
        alert('Failed to connect to server');
        return;
      }
    }

    const message: LoginReq = {
      type: MessageType.LOGIN_REQ,
      account,
      password,
    };

    this.wsClient.send(message);
  }

  private handleLoginResponse(message: LoginAck): void {
    if (message.result === LoginResult.SUCCEED) {
      this.hide();
      if (this.onLoginSuccessCallback) {
        this.onLoginSuccessCallback(message);
      }
    } else {
      alert(`Login failed: ${message.result}`);
    }
  }
}

