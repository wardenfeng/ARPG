export interface AnimationFrame {
  index: number;
  duration: number; // in seconds
}

export class Animation {
  private frames: number[];
  private currentFrameIndex: number = 0;
  private frameTime: number = 0;
  private speed: number = 1.0; // frames per second
  private loop: boolean = true;
  private playing: boolean = false;
  private onComplete?: () => void;

  constructor(frames: number[], speed: number = 8, loop: boolean = true) {
    this.frames = frames;
    this.speed = speed;
    this.loop = loop;
  }

  play(): void {
    this.playing = true;
    this.currentFrameIndex = 0;
    this.frameTime = 0;
  }

  stop(): void {
    this.playing = false;
  }

  reset(): void {
    this.currentFrameIndex = 0;
    this.frameTime = 0;
  }

  update(deltaTime: number): void {
    if (!this.playing) return;

    this.frameTime += deltaTime;
    const frameDuration = 1.0 / this.speed;

    if (this.frameTime >= frameDuration) {
      this.frameTime -= frameDuration;
      this.currentFrameIndex++;

      if (this.currentFrameIndex >= this.frames.length) {
        if (this.loop) {
          this.currentFrameIndex = 0;
        } else {
          this.currentFrameIndex = this.frames.length - 1;
          this.playing = false;
          if (this.onComplete) {
            this.onComplete();
          }
        }
      }
    }
  }

  getCurrentFrame(): number {
    if (this.frames.length === 0) return 0;
    return this.frames[this.currentFrameIndex];
  }

  isPlaying(): boolean {
    return this.playing;
  }

  setSpeed(speed: number): void {
    this.speed = speed;
  }

  setOnComplete(callback: () => void): void {
    this.onComplete = callback;
  }
}

