import { Animation } from './Animation';
import { AnimationController } from './AnimationController';
import { SpriteSheet } from './SpriteSheet';

export enum ActionType {
  STAND = 'stand',
  WALK = 'walk',
  RUN = 'run',
  ATTACK = 'attack',
  CAST_SKILL = 'castSkill',
  BE_ATTACKED = 'beAttacked',
  FELL_DOWN = 'fellDown',
}

export enum Direction {
  DOWN = 0,
  LEFT = 1,
  UP = 2,
  RIGHT = 3,
  DOWN_LEFT = 4,
}

export interface PlayerAnimationConfig {
  actions: {
    [key in ActionType]?: {
      frames: string; // e.g., "0|1|2|3|4|5"
      speed: number;
    };
  };
  directions: Direction[];
}

export class PlayerAnimation {
  private controller: AnimationController;
  private spriteSheet: SpriteSheet;
  private currentAction: ActionType = ActionType.STAND;
  private currentDirection: Direction = Direction.DOWN;
  private config: PlayerAnimationConfig;

  constructor(spriteSheet: SpriteSheet, config: PlayerAnimationConfig) {
    this.spriteSheet = spriteSheet;
    this.config = config;
    this.controller = new AnimationController();
    this.setupAnimations();
  }

  private setupAnimations(): void {
    const { actions, directions } = this.config;

    directions.forEach((direction, dirIndex) => {
      Object.entries(actions).forEach(([actionName, actionConfig]) => {
        if (actionConfig) {
          const frameIndices = actionConfig.frames.split('|').map(Number);
          // Calculate actual frame indices based on direction
          const actualFrames = frameIndices.map(frame => frame + dirIndex * this.spriteSheet.getFrameCount() / directions.length);
          const animation = new Animation(actualFrames, actionConfig.speed, true);
          const animationName = `${actionName}_${direction}`;
          this.controller.addAnimation(animationName, animation);
        }
      });
    });
  }

  setAction(action: ActionType): void {
    if (this.currentAction !== action) {
      this.currentAction = action;
      this.updateAnimation();
    }
  }

  setDirection(direction: Direction): void {
    if (this.currentDirection !== direction) {
      this.currentDirection = direction;
      this.updateAnimation();
    }
  }

  private updateAnimation(): void {
    const animationName = `${this.currentAction}_${this.currentDirection}`;
    this.controller.playAnimation(animationName);
  }

  update(deltaTime: number): void {
    this.controller.update(deltaTime);
  }

  getCurrentFrame(): number {
    return this.controller.getCurrentFrame();
  }

  getCurrentFrameData() {
    const frameIndex = this.getCurrentFrame();
    return this.spriteSheet.getFrame(frameIndex);
  }

  getAction(): ActionType {
    return this.currentAction;
  }

  getDirection(): Direction {
    return this.currentDirection;
  }
}

