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
  
  // 移动相关
  private targetMapX: number = 0;
  private targetMapY: number = 0;
  private isMoving: boolean = false;
  private moveSpeed: number = 200; // 像素/秒
  private currentWorldX: number = 0;
  private currentWorldY: number = 0;

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
    this.currentWorldX = this.floorX;
    this.currentWorldY = this.floorY;
  }

  setTargetPosition(targetMapX: number, targetMapY: number, _tileWidth: number, _tileHeight: number): void {
    this.targetMapX = targetMapX;
    this.targetMapY = targetMapY;
    this.isMoving = true;
    
    // 设置移动动画
    if (this.animation) {
      this.animation.setAction(ActionType.WALK);
    }
  }

  stopMoving(): void {
    this.isMoving = false;
    if (this.animation) {
      this.animation.setAction(ActionType.STAND);
    }
  }

  getIsMoving(): boolean {
    return this.isMoving;
  }

  getTargetMapX(): number {
    return this.targetMapX;
  }

  getTargetMapY(): number {
    return this.targetMapY;
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

  update(deltaTime: number, tileWidth?: number, tileHeight?: number): void {
    if (this.animation) {
      this.animation.update(deltaTime);
    }

    // 处理移动（需要 tileWidth 和 tileHeight）
    if (this.isMoving && tileWidth !== undefined && tileHeight !== undefined) {
      const targetWorldX = this.targetMapX * tileWidth;
      const targetWorldY = this.targetMapY * tileHeight;
      
      const dx = targetWorldX - this.currentWorldX;
      const dy = targetWorldY - this.currentWorldY;
      const distance = Math.sqrt(dx * dx + dy * dy);
      
      if (distance < 1) {
        // 到达目标位置
        this.mapX = this.targetMapX;
        this.mapY = this.targetMapY;
        this.floorX = targetWorldX;
        this.floorY = targetWorldY;
        this.currentWorldX = targetWorldX;
        this.currentWorldY = targetWorldY;
        this.stopMoving();
      } else {
        // 按移动速度移动
        const moveDistance = this.moveSpeed * deltaTime;
        const moveX = (dx / distance) * moveDistance;
        const moveY = (dy / distance) * moveDistance;
        
        // 如果移动距离超过剩余距离，直接到达目标
        if (moveDistance >= distance) {
          this.currentWorldX = targetWorldX;
          this.currentWorldY = targetWorldY;
          this.mapX = this.targetMapX;
          this.mapY = this.targetMapY;
          this.floorX = targetWorldX;
          this.floorY = targetWorldY;
          this.stopMoving();
        } else {
          this.currentWorldX += moveX;
          this.currentWorldY += moveY;
          this.floorX = this.currentWorldX;
          this.floorY = this.currentWorldY;
          
          // 更新地图坐标（用于相机跟随）
          if (tileWidth !== undefined && tileHeight !== undefined) {
            this.mapX = Math.floor(this.currentWorldX / tileWidth);
            this.mapY = Math.floor(this.currentWorldY / tileHeight);
          }
        }

        // 更新移动方向
        if (this.animation && distance > 0.1) {
          if (Math.abs(dx) > Math.abs(dy)) {
            this.animation.setDirection(dx > 0 ? Direction.RIGHT : Direction.LEFT);
          } else {
            this.animation.setDirection(dy > 0 ? Direction.DOWN : Direction.UP);
          }
        }
      }
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

