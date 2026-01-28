export interface SpriteSheetConfig {
  image: string;
  frameWidth: number;
  frameHeight: number;
  columns: number;
  rows: number;
  spacing?: number;
  margin?: number;
}

export interface SpriteSheetFrame {
  x: number;
  y: number;
  width: number;
  height: number;
  u0: number;
  v0: number;
  u1: number;
  v1: number;
}

export class SpriteSheet {
  private config: SpriteSheetConfig;
  private frames: SpriteSheetFrame[] = [];
  private textureWidth: number = 0;
  private textureHeight: number = 0;

  constructor(config: SpriteSheetConfig) {
    this.config = config;
    this.calculateFrames();
  }

  private calculateFrames(): void {
    const { frameWidth, frameHeight, columns, rows, spacing = 0, margin = 0 } = this.config;
    
    this.textureWidth = columns * frameWidth + (columns - 1) * spacing + margin * 2;
    this.textureHeight = rows * frameHeight + (rows - 1) * spacing + margin * 2;

    for (let row = 0; row < rows; row++) {
      for (let col = 0; col < columns; col++) {
        const x = margin + col * (frameWidth + spacing);
        const y = margin + row * (frameHeight + spacing);

        const frame: SpriteSheetFrame = {
          x,
          y,
          width: frameWidth,
          height: frameHeight,
          u0: x / this.textureWidth,
          v0: y / this.textureHeight,
          u1: (x + frameWidth) / this.textureWidth,
          v1: (y + frameHeight) / this.textureHeight,
        };

        this.frames.push(frame);
      }
    }
  }

  getFrame(index: number): SpriteSheetFrame | undefined {
    return this.frames[index];
  }

  getFrameCount(): number {
    return this.frames.length;
  }

  getConfig(): SpriteSheetConfig {
    return this.config;
  }
}

