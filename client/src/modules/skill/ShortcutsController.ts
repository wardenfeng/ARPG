import { SkillController } from './SkillController';
import { AttackType } from '../../network/Protocol';
import { EventBus } from '../../core/EventBus';

export class ShortcutsController {
  private skillController: SkillController;
  private eventBus: EventBus;

  constructor(eventBus: EventBus, skillController: SkillController) {
    this.eventBus = eventBus;
    this.skillController = skillController;
    this.setupShortcuts();
  }

  private setupShortcuts(): void {
    document.addEventListener('keydown', (e) => {
      // Key '1' for skill casting
      if (e.key === '1') {
        this.castSkill();
      }
    });
  }

  private castSkill(): void {
    // Default skill ID and attack type
    // This will be enhanced to support targeting
    this.skillController.castSkill(1, AttackType.POINT);
    this.eventBus.emit('shortcut:skill');
  }
}

