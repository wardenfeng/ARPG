import { ISceneItem } from '../ISceneItem';
import { Sprite } from '../../renderer/Sprite';
import { PlayerAnimation, ActionType, Direction } from '../../animation/PlayerAnimation';

export class PlayerEntity implements ISceneItem {
  public playerId: number;
  public username: string;
  private floorX: number = 0;
  private floorY: number = 0;
  private mapX: number = 0;
  private mapY: number = 0;
  private sprite: Sprite | null = null;
  private animation: PlayerAnimation | null = null;
  public hp: number = 100;
  public mp: number = 50;

  constructor(playerId: number, username: string, mapX: number, mapY: number) {
    this.playerId = playerId;
    this.username = username;
    this.mapX = mapX;
    this.mapY = mapY;
  }

  setSprite(sprite: Sprite): void {
    this.sprite = sprite;
  }

  setAnimation(animation: PlayerAnimation): void {
    this.animation = animation;
  }

  setMapPosition(mapX: number, mapY: number, tileWidth: number, tileHeight: number): void {
    this.mapX = mapX;
    this.mapY = mapY;
    this.floorX = mapX * tileWidth;
    this.floorY = mapY * tileHeight;
  }

  getFloorX(): number {
    return this.floorX;
  }

  getFloorY(): number {
    return this.floorY;
  }

  getMapX(): number {
    return this.mapX;
  }

  getMapY(): number {
    return this.mapY;
  }

  getSprite(): Sprite | null {
    return this.sprite;
  }

  getAnimation(): PlayerAnimation | null {
    return this.animation;
  }

  update(deltaTime: number): void {
    if (this.animation) {
      this.animation.update(deltaTime);
    }
  }

  setAction(action: ActionType): void {
    if (this.animation) {
      this.animation.setAction(action);
    }
  }

  setDirection(direction: Direction): void {
    if (this.animation) {
      this.animation.setDirection(direction);
    }
  }
}

