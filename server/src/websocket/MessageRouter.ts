import { WebSocket } from 'ws';
import { GameMessage, MessageType } from '../types/Protocol';
import { LoginHandler } from '../handlers/LoginHandler';
import { MoveHandler } from '../handlers/MoveHandler';
import { SkillHandler } from '../handlers/SkillHandler';
import { ChatHandler } from '../handlers/ChatHandler';

export class MessageRouter {
  private loginHandler: LoginHandler;
  private moveHandler: MoveHandler;
  private skillHandler: SkillHandler;
  private chatHandler: ChatHandler;

  constructor(
    loginHandler: LoginHandler,
    moveHandler: MoveHandler,
    skillHandler: SkillHandler,
    chatHandler: ChatHandler
  ) {
    this.loginHandler = loginHandler;
    this.moveHandler = moveHandler;
    this.skillHandler = skillHandler;
    this.chatHandler = chatHandler;
  }

  route(ws: WebSocket, message: GameMessage): void {
    switch (message.type) {
      case MessageType.LOGIN_REQ:
        this.loginHandler.handle(ws, message);
        break;
      case MessageType.MOVE_REQ:
        this.moveHandler.handle(ws, message);
        break;
      case MessageType.CAST_SKILL_REQ:
        this.skillHandler.handle(ws, message);
        break;
      case MessageType.CHAT_REQ:
        this.chatHandler.handle(ws, message);
        break;
      default:
        console.warn('Unknown message type:', message.type);
    }
  }

  handleDisconnect(ws: WebSocket): void {
    // Handle client disconnect
    this.loginHandler.handleDisconnect(ws);
  }
}

