export class GameLoop {
  private updateFn: (deltaTime: number) => void;
  private renderFn: () => void;
  private running: boolean = false;
  private lastTime: number = 0;
  private animationFrameId: number = 0;

  constructor(
    updateFn: (deltaTime: number) => void,
    renderFn: () => void
  ) {
    this.updateFn = updateFn;
    this.renderFn = renderFn;
  }

  start(): void {
    if (this.running) return;
    this.running = true;
    this.lastTime = performance.now();
    this.tick();
  }

  stop(): void {
    this.running = false;
    if (this.animationFrameId) {
      cancelAnimationFrame(this.animationFrameId);
    }
  }

  private tick = (): void => {
    if (!this.running) return;

    const currentTime = performance.now();
    const deltaTime = (currentTime - this.lastTime) / 1000; // Convert to seconds
    this.lastTime = currentTime;

    this.updateFn(deltaTime);
    this.renderFn();

    this.animationFrameId = requestAnimationFrame(this.tick);
  };
}

