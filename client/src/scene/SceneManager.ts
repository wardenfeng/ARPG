import { GameScene } from './GameScene';
import { MapRenderer } from './MapRenderer';
import { WebGLRenderer } from '../renderer/WebGLRenderer';
import { SpriteRenderer } from '../renderer/SpriteRenderer';
import { ResourceLoader } from '../core/ResourceLoader';
import { ISceneItem } from './ISceneItem';
import { PlayerEntity } from './entities/PlayerEntity';

export class SceneManager {
  private currentScene: GameScene;
  private mapRenderer: MapRenderer;
  private renderer: WebGLRenderer;
  private spriteRenderer: SpriteRenderer;
  private cameraTargetX: number = 0;
  private cameraTargetY: number = 0;
  private cameraX: number = 0;
  private cameraY: number = 0;
  private cameraSpeed: number = 5.0;

  constructor(renderer: WebGLRenderer, spriteRenderer: SpriteRenderer, resourceLoader: ResourceLoader) {
    this.renderer = renderer;
    this.spriteRenderer = spriteRenderer;
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

  /**
   * 立即设置相机位置（不经过平滑跟随，用于初始定位）
   */
  setCameraPosition(x: number, y: number): void {
    this.cameraX = x;
    this.cameraY = y;
    this.cameraTargetX = x;
    this.cameraTargetY = y;
  }

  /**
   * 将地图坐标转换为世界坐标（像素坐标）
   */
  mapToWorld(mapX: number, mapY: number): { worldX: number; worldY: number } {
    const mapConfig = this.mapRenderer.getConfig();
    if (!mapConfig) {
      return { worldX: 0, worldY: 0 };
    }
    const worldX = mapX * mapConfig.walkGridWidth;
    const worldY = mapY * mapConfig.walkGridHeight;
    return { worldX, worldY };
  }

  /**
   * 立即定位相机到玩家位置（用于登录时立即显示玩家）
   */
  setCameraToPlayer(playerMapX: number, playerMapY: number): void {
    const { worldX, worldY } = this.mapToWorld(playerMapX, playerMapY);
    const canvas = this.renderer.getCanvas();
    // 减去视口一半，使玩家在屏幕中心
    const targetX = worldX - canvas.width / 2;
    const targetY = worldY - canvas.height / 2;
    this.setCameraPosition(targetX, targetY);
  }

  /**
   * 跟随玩家位置（将相机目标设置为玩家位置，使玩家在屏幕中心）
   * 使用平滑跟随，用于玩家移动时
   */
  followPlayer(playerMapX: number, playerMapY: number): void {
    const { worldX, worldY } = this.mapToWorld(playerMapX, playerMapY);
    const canvas = this.renderer.getCanvas();
    // 减去视口一半，使玩家在屏幕中心
    const targetX = worldX - canvas.width / 2;
    const targetY = worldY - canvas.height / 2;
    this.setCameraTarget(targetX, targetY);
  }

  update(deltaTime: number): void {
    // 检查是否有当前玩家，如果有则跟随玩家位置
    const currentPlayerId = (window as any).__currentPlayerId;
    if (currentPlayerId !== undefined) {
      // 从场景中查找当前玩家实体
      const items = this.currentScene.getItems();
      for (const item of items) {
        if (item instanceof PlayerEntity && item.playerId === currentPlayerId) {
          const playerMapX = item.getMapX();
          const playerMapY = item.getMapY();
          
          // 计算玩家应该的相机目标位置
          const { worldX, worldY } = this.mapToWorld(playerMapX, playerMapY);
          const canvas = this.renderer.getCanvas();
          const expectedTargetX = worldX - canvas.width / 2;
          const expectedTargetY = worldY - canvas.height / 2;
          
          // 只有当玩家位置真正改变时才更新相机目标，避免不必要的更新导致抖动
          const targetDistance = Math.sqrt(
            Math.pow(this.cameraTargetX - expectedTargetX, 2) + 
            Math.pow(this.cameraTargetY - expectedTargetY, 2)
          );
          
          // 如果目标位置变化超过阈值（比如 5 像素），才更新相机目标
          if (targetDistance > 5) {
            this.followPlayer(playerMapX, playerMapY);
          }
          break;
        }
      }
    }

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
      this.renderItem(item);
    });
  }

  private renderItem(item: ISceneItem): void {
    // 计算屏幕坐标（世界坐标 - 相机坐标）
    const worldX = item.getFloorX();
    const worldY = item.getFloorY();
    const screenX = worldX - this.cameraX;
    const screenY = worldY - this.cameraY;

    // 检查是否在视口内（添加一些边距以支持部分可见）
    const canvas = this.renderer.getCanvas();
    const margin = 200; // 边距，允许部分在屏幕外的物体也被渲染
    if (screenX + margin < 0 || screenX - margin > canvas.width ||
        screenY + margin < 0 || screenY - margin > canvas.height) {
      return; // 不在视口内，跳过渲染
    }

    // 处理 PlayerEntity
    if (item instanceof PlayerEntity) {
      this.renderPlayerEntity(item, screenX, screenY);
    }
    // 可以在这里添加其他实体类型的渲染逻辑
  }

  private renderPlayerEntity(player: PlayerEntity, screenX: number, screenY: number): void {
    // 优先使用动画的当前帧
    const animation = player.getAnimation();
    const sprite = player.getSprite();

    if (animation && sprite && sprite.texture) {
      // 获取当前帧数据
      const frameData = animation.getCurrentFrameData();
      if (frameData) {
        // 更新 sprite 的纹理坐标
        sprite.setTextureCoords(frameData.u0, frameData.v0, frameData.u1, frameData.v1);
        sprite.width = frameData.width;
        sprite.height = frameData.height;
      }

      // 渲染 sprite
      this.spriteRenderer.render(sprite, screenX, screenY, sprite.width, sprite.height);
    } else if (sprite && sprite.texture) {
      // 如果没有动画，直接渲染 sprite
      this.spriteRenderer.render(sprite, screenX, screenY, sprite.width, sprite.height);
    }
    // 如果没有 sprite，不渲染（可能资源还在加载中）
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

