import { ISceneItem } from './ISceneItem';

export class GameScene {
  private items: ISceneItem[] = [];
  private cameraX: number = 0;
  private cameraY: number = 0;
  private cameraWidth: number = 0;
  private cameraHeight: number = 0;

  addItem(item: ISceneItem): void {
    this.items.push(item);
    this.sortItems();
  }

  removeItem(item: ISceneItem): void {
    const index = this.items.indexOf(item);
    if (index > -1) {
      this.items.splice(index, 1);
    }
  }

  getItems(): ISceneItem[] {
    return this.items;
  }

  setCamera(x: number, y: number, width: number, height: number): void {
    this.cameraX = x;
    this.cameraY = y;
    this.cameraWidth = width;
    this.cameraHeight = height;
  }

  getCameraX(): number {
    return this.cameraX;
  }

  getCameraY(): number {
    return this.cameraY;
  }

  getCameraWidth(): number {
    return this.cameraWidth;
  }

  getCameraHeight(): number {
    return this.cameraHeight;
  }

  private sortItems(): void {
    // Sort by Y coordinate for depth sorting
    this.items.sort((a, b) => {
      const aY = a.getFloorY();
      const bY = b.getFloorY();
      return aY - bY;
    });
  }

  update(deltaTime: number): void {
    this.items.forEach(item => {
      if (item.update) {
        item.update(deltaTime);
      }
    });
    this.sortItems();
  }

  clear(): void {
    this.items = [];
  }
}

