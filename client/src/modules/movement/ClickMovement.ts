import { MapTileModel } from '../../pathfinding/MapTileModel';
import { EventBus } from '../../core/EventBus';

export class ClickMovement {
  private tileWidth: number = 50;
  private tileHeight: number = 25;
  private eventBus: EventBus;
  private canvas: HTMLCanvasElement;

  constructor(canvas: HTMLCanvasElement, eventBus: EventBus) {
    this.canvas = canvas;
    this.eventBus = eventBus;
    this.setupClickHandler();
  }

  setMapTileModel(_mapTileModel: MapTileModel, tileWidth: number, tileHeight: number): void {
    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;
  }

  private setupClickHandler(): void {
    this.canvas.addEventListener('click', (e) => {
      const rect = this.canvas.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      
      this.handleClick(x, y);
    });
  }

  private handleClick(screenX: number, screenY: number): void {
    // Convert screen coordinates to map coordinates
    // This will be handled by the scene manager with camera offset
    this.eventBus.emit('click:map', { x: screenX, y: screenY });
  }

  convertScreenToMap(screenX: number, screenY: number, cameraX: number, cameraY: number): { mapX: number; mapY: number } {
    const mapX = Math.floor((screenX + cameraX) / this.tileWidth);
    const mapY = Math.floor((screenY + cameraY) / this.tileHeight);
    return { mapX, mapY };
  }
}

