import { Animation } from './Animation';

export class AnimationController {
  private currentAnimation: Animation | null = null;
  private animations: Map<string, Animation> = new Map();

  addAnimation(name: string, animation: Animation): void {
    this.animations.set(name, animation);
  }

  playAnimation(name: string): void {
    const animation = this.animations.get(name);
    if (animation) {
      if (this.currentAnimation) {
        this.currentAnimation.stop();
      }
      this.currentAnimation = animation;
      animation.play();
    }
  }

  stopAnimation(): void {
    if (this.currentAnimation) {
      this.currentAnimation.stop();
    }
  }

  update(deltaTime: number): void {
    if (this.currentAnimation) {
      this.currentAnimation.update(deltaTime);
    }
  }

  getCurrentFrame(): number {
    if (this.currentAnimation) {
      return this.currentAnimation.getCurrentFrame();
    }
    return 0;
  }

  getCurrentAnimation(): Animation | null {
    return this.currentAnimation;
  }
}

