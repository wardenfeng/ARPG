import { WebSocketClient } from '../../network/WebSocketClient';
import { MessageType, CastSkillReq, AttackType, CastSkillNtf } from '../../network/Protocol';
import { EventBus } from '../../core/EventBus';

export class SkillController {
  private wsClient: WebSocketClient | null = null;
  private eventBus: EventBus;

  constructor(eventBus: EventBus) {
    this.eventBus = eventBus;
  }

  setWebSocketClient(wsClient: WebSocketClient): void {
    this.wsClient = wsClient;
    
    // Listen for skill notifications
    this.eventBus.on('message:CAST_SKILL_NTF', (message: CastSkillNtf) => {
      this.handleSkillNotification(message);
    });
  }

  castSkill(skillId: number, attackType: AttackType, targetId?: number, mapX?: number, mapY?: number): void {
    if (!this.wsClient || !this.wsClient.isConnected()) {
      console.warn('WebSocket not connected');
      return;
    }

    const message: CastSkillReq = {
      type: MessageType.CAST_SKILL_REQ,
      skillId,
      attackType,
      targetId,
      mapX,
      mapY,
    };

    this.wsClient.send(message);
    this.eventBus.emit('skill:cast:request', message);
  }

  private handleSkillNotification(message: CastSkillNtf): void {
    this.eventBus.emit('skill:cast:notification', message);
  }
}

