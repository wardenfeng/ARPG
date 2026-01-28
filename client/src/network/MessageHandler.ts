import { GameMessage, MessageType } from './Protocol';
import { EventBus } from '../core/EventBus';

export class MessageHandler {
  private eventBus: EventBus;

  constructor(eventBus: EventBus) {
    this.eventBus = eventBus;
  }

  handle(message: GameMessage): void {
    // Emit message-specific events
    this.eventBus.emit(`message:${message.type}`, message);
    
    // Also emit generic message event
    this.eventBus.emit('message', message);

    // Handle specific message types
    switch (message.type) {
      case MessageType.LOGIN_ACK:
        this.handleLoginAck(message);
        break;
      case MessageType.MOVE_ACK:
        this.handleMoveAck(message);
        break;
      case MessageType.MOVE_NTF:
        this.handleMoveNtf(message);
        break;
      case MessageType.ADD_PLAYER_NTF:
        this.handleAddPlayerNtf(message);
        break;
      case MessageType.REMOVE_PLAYER_NTF:
        this.handleRemovePlayerNtf(message);
        break;
      case MessageType.CAST_SKILL_ACK:
        this.handleCastSkillAck(message);
        break;
      case MessageType.CAST_SKILL_NTF:
        this.handleCastSkillNtf(message);
        break;
      case MessageType.HP_UPDATE_NTF:
        this.handleHPUpdateNtf(message);
        break;
      case MessageType.MP_UPDATE_NTF:
        this.handleMPUpdateNtf(message);
        break;
      case MessageType.ADD_MONSTER_NTF:
        this.handleAddMonsterNtf(message);
        break;
      case MessageType.CHAT_NTF:
        this.handleChatNtf(message);
        break;
    }
  }

  private handleLoginAck(message: any): void {
    this.eventBus.emit('login:result', message);
  }

  private handleMoveAck(message: any): void {
    this.eventBus.emit('move:result', message);
  }

  private handleMoveNtf(message: any): void {
    this.eventBus.emit('move:notification', message);
  }

  private handleAddPlayerNtf(message: any): void {
    this.eventBus.emit('player:add', message);
  }

  private handleRemovePlayerNtf(message: any): void {
    this.eventBus.emit('player:remove', message);
  }

  private handleCastSkillAck(message: any): void {
    this.eventBus.emit('skill:cast:result', message);
  }

  private handleCastSkillNtf(message: any): void {
    this.eventBus.emit('skill:cast:notification', message);
  }

  private handleHPUpdateNtf(message: any): void {
    this.eventBus.emit('hp:update', message);
  }

  private handleMPUpdateNtf(message: any): void {
    this.eventBus.emit('mp:update', message);
  }

  private handleAddMonsterNtf(message: any): void {
    this.eventBus.emit('monster:add', message);
  }

  private handleChatNtf(message: any): void {
    this.eventBus.emit('chat:message', message);
  }
}

