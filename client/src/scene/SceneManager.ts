import { GameScene } from './GameScene';
import { MapRenderer } from './MapRenderer';
import { WebGLRenderer } from '../renderer/WebGLRenderer';
import { SpriteRenderer } from '../renderer/SpriteRenderer';
import { ResourceLoader } from '../core/ResourceLoader';
import { ISceneItem } from './ISceneItem';

export class SceneManager {
  private currentScene: GameScene;
  private mapRenderer: MapRenderer;
  private renderer: WebGLRenderer;
  private cameraTargetX: number = 0;
  private cameraTargetY: number = 0;
  private cameraX: number = 0;
  private cameraY: number = 0;
  private cameraSpeed: number = 5.0;

  constructor(renderer: WebGLRenderer, spriteRenderer: SpriteRenderer, resourceLoader: ResourceLoader) {
    this.renderer = renderer;
    this.mapRenderer = new MapRenderer(renderer, spriteRenderer, resourceLoader);
    this.currentScene = new GameScene();
    
    this.updateCameraSize();
    window.addEventListener('resize', () => this.updateCameraSize());
  }

  private updateCameraSize(): void {
    const canvas = this.renderer.getCanvas();
    this.mapRenderer.setCamera(this.cameraX, this.cameraY, canvas.width, canvas.height);
  }

  getScene(): GameScene {
    return this.currentScene;
  }

  getMapRenderer(): MapRenderer {
    return this.mapRenderer;
  }

  setCameraTarget(x: number, y: number): void {
    this.cameraTargetX = x;
    this.cameraTargetY = y;
  }

  update(deltaTime: number): void {
    // Smooth camera follow
    const dx = this.cameraTargetX - this.cameraX;
    const dy = this.cameraTargetY - this.cameraY;
    const distance = Math.sqrt(dx * dx + dy * dy);
    
    if (distance > 1) {
      const moveDistance = this.cameraSpeed * deltaTime * 60;
      const moveX = (dx / distance) * moveDistance;
      const moveY = (dy / distance) * moveDistance;
      
      this.cameraX += moveX;
      this.cameraY += moveY;
    } else {
      this.cameraX = this.cameraTargetX;
      this.cameraY = this.cameraTargetY;
    }

    const canvas = this.renderer.getCanvas();
    this.mapRenderer.setCamera(this.cameraX, this.cameraY, canvas.width, canvas.height);
    this.currentScene.setCamera(this.cameraX, this.cameraY, canvas.width, canvas.height);
    
    this.currentScene.update(deltaTime);
  }

  render(): void {
    // Render map
    this.mapRenderer.render();
    
    // Render scene items
    const items = this.currentScene.getItems();
    items.forEach(item => {
      // Render item at screen position
      // This will be implemented by specific item types
      // Screen position calculation: item.getFloorX() - this.cameraX, item.getFloorY() - this.cameraY
    });
  }

  addItem(item: ISceneItem): void {
    this.currentScene.addItem(item);
  }

  removeItem(item: ISceneItem): void {
    this.currentScene.removeItem(item);
  }

  getCameraX(): number {
    return this.cameraX;
  }

  getCameraY(): number {
    return this.cameraY;
  }
}

