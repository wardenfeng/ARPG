import { WebGLRenderer } from '../renderer/WebGLRenderer';
import { SpriteRenderer } from '../renderer/SpriteRenderer';
import { Texture } from '../renderer/Texture';
import { Sprite } from '../renderer/Sprite';
import { ResourceLoader } from '../core/ResourceLoader';

export interface MapConfig {
  mapId: number;
  mapWidth: number;
  mapHeight: number;
  tileWidth: number;
  tileHeight: number;
  rows: number;
  columns: number;
  mapData: number[][];
}

export class MapRenderer {
  private spriteRenderer: SpriteRenderer;
  private resourceLoader: ResourceLoader;
  private config: MapConfig | null = null;
  private loadedTiles: Map<string, Texture> = new Map();
  private tileSprites: Map<string, Sprite> = new Map();
  private cameraX: number = 0;
  private cameraY: number = 0;
  private viewWidth: number = 0;
  private viewHeight: number = 0;

  constructor(_renderer: WebGLRenderer, spriteRenderer: SpriteRenderer, resourceLoader: ResourceLoader) {
    this.spriteRenderer = spriteRenderer;
    this.resourceLoader = resourceLoader;
  }

  async loadMap(config: MapConfig, basePath: string): Promise<void> {
    this.config = config;
    // Preload visible tiles
    await this.preloadVisibleTiles(basePath);
  }

  private async preloadVisibleTiles(basePath: string): Promise<void> {
    if (!this.config) return;

    const startX = Math.floor(this.cameraX / this.config.tileWidth);
    const startY = Math.floor(this.cameraY / this.config.tileHeight);
    const endX = Math.ceil((this.cameraX + this.viewWidth) / this.config.tileWidth);
    const endY = Math.ceil((this.cameraY + this.viewHeight) / this.config.tileHeight);

    const loadPromises: Promise<void>[] = [];

    for (let x = startX; x < endX; x++) {
      for (let y = startY; y < endY; y++) {
        if (x >= 0 && y >= 0 && x < this.config.columns && y < this.config.rows) {
          const tileKey = `${x}_${y}`;
          if (!this.loadedTiles.has(tileKey)) {
            const url = `${basePath}/${x}_${y}.jpg`;
            loadPromises.push(this.loadTile(tileKey, url));
          }
        }
      }
    }

    await Promise.all(loadPromises);
  }

  private async loadTile(key: string, url: string): Promise<void> {
    try {
      const texture = await this.resourceLoader.loadTexture(key, url);
      this.loadedTiles.set(key, texture);
      
      const sprite = new Sprite(texture);
      this.tileSprites.set(key, sprite);
    } catch (error) {
      console.warn(`Failed to load tile ${key}:`, error);
    }
  }

  setCamera(x: number, y: number, width: number, height: number): void {
    this.cameraX = x;
    this.cameraY = y;
    this.viewWidth = width;
    this.viewHeight = height;
    
    // Load new tiles if needed
    if (this.config) {
      this.preloadVisibleTiles('').catch(console.error);
    }
  }

  render(): void {
    if (!this.config) return;

    const startX = Math.floor(this.cameraX / this.config.tileWidth);
    const startY = Math.floor(this.cameraY / this.config.tileHeight);
    const endX = Math.ceil((this.cameraX + this.viewWidth) / this.config.tileWidth);
    const endY = Math.ceil((this.cameraY + this.viewHeight) / this.config.tileHeight);

    for (let x = startX; x < endX; x++) {
      for (let y = startY; y < endY; y++) {
        if (x >= 0 && y >= 0 && x < this.config.columns && y < this.config.rows) {
          const tileKey = `${x}_${y}`;
          const sprite = this.tileSprites.get(tileKey);
          
          if (sprite) {
            const tileX = x * this.config.tileWidth;
            const tileY = y * this.config.tileHeight;
            const screenX = tileX - this.cameraX;
            const screenY = tileY - this.cameraY;
            
            this.spriteRenderer.render(sprite, screenX, screenY);
          }
        }
      }
    }
  }

  getConfig(): MapConfig | null {
    return this.config;
  }
}

