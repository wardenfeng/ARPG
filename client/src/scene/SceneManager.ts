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
  private uiCanvas: HTMLCanvasElement;
  private uiContext: CanvasRenderingContext2D;
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
    
    // 创建 UI canvas 用于绘制玩家信息（名称和血条）
    this.uiCanvas = document.createElement('canvas');
    this.uiCanvas.style.position = 'absolute';
    this.uiCanvas.style.top = '0';
    this.uiCanvas.style.left = '0';
    this.uiCanvas.style.pointerEvents = 'none';
    this.uiCanvas.style.zIndex = '100';
    const gameCanvas = renderer.getCanvas();
    gameCanvas.parentElement?.appendChild(this.uiCanvas);
    
    const uiCtx = this.uiCanvas.getContext('2d');
    if (!uiCtx) {
      throw new Error('Failed to get 2D context for UI canvas');
    }
    this.uiContext = uiCtx;
    
    // 同步 UI canvas 尺寸
    this.resizeUICanvas();
    
    this.updateCameraSize();
    window.addEventListener('resize', () => {
      this.updateCameraSize();
      this.resizeUICanvas();
    });
  }

  private resizeUICanvas(): void {
    const gameCanvas = this.renderer.getCanvas();
    this.uiCanvas.width = gameCanvas.width;
    this.uiCanvas.height = gameCanvas.height;
    this.uiCanvas.style.width = `${gameCanvas.width}px`;
    this.uiCanvas.style.height = `${gameCanvas.height}px`;
  }

  private updateCameraSize(): void {
    const canvas = this.renderer.getCanvas();
    
    // 如果窗口大小改变，需要重新计算相机位置以保持玩家在屏幕中心
    const currentPlayerId = (window as any).__currentPlayerId;
    if (currentPlayerId !== undefined) {
      // 从场景中查找当前玩家实体
      const items = this.currentScene.getItems();
      for (const item of items) {
        if (item instanceof PlayerEntity && item.playerId === currentPlayerId) {
          const playerMapX = item.getMapX();
          const playerMapY = item.getMapY();
          
          // 重新计算相机位置，使玩家保持在屏幕中心
          const { worldX, worldY } = this.mapToWorld(playerMapX, playerMapY);
          let targetX = worldX - canvas.width / 2;
          let targetY = worldY - canvas.height / 2;
          
          // 限制相机位置在地图边界内
          const clamped = this.clampCameraPosition(targetX, targetY);
          targetX = clamped.x;
          targetY = clamped.y;
          
          // 立即更新相机位置和目标，避免抖动
          this.cameraX = targetX;
          this.cameraY = targetY;
          this.cameraTargetX = targetX;
          this.cameraTargetY = targetY;
          
          break;
        }
      }
    }
    
    // 更新地图渲染器的相机和视口
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
   * 限制相机位置在地图边界内，避免显示地图外的黑色区域
   */
  private clampCameraPosition(x: number, y: number): { x: number; y: number } {
    const canvas = this.renderer.getCanvas();
    const mapConfig = this.mapRenderer.getConfig();
    
    if (!mapConfig) {
      return { x, y };
    }

    const mapWidth = mapConfig.mapWidth;
    const mapHeight = mapConfig.mapHeight;
    const viewWidth = canvas.width;
    const viewHeight = canvas.height;

    // 限制相机位置，确保视口不超出地图边界
    // 左边界：相机 X 不能小于 0
    const minX = 0;
    // 右边界：相机 X 不能大于 mapWidth - viewWidth
    const maxX = Math.max(0, mapWidth - viewWidth);
    // 上边界：相机 Y 不能小于 0
    const minY = 0;
    // 下边界：相机 Y 不能大于 mapHeight - viewHeight
    const maxY = Math.max(0, mapHeight - viewHeight);

    const clampedX = Math.max(minX, Math.min(maxX, x));
    const clampedY = Math.max(minY, Math.min(maxY, y));

    return { x: clampedX, y: clampedY };
  }

  /**
   * 立即定位相机到玩家位置（用于登录时立即显示玩家）
   */
  setCameraToPlayer(playerMapX: number, playerMapY: number): void {
    const { worldX, worldY } = this.mapToWorld(playerMapX, playerMapY);
    const canvas = this.renderer.getCanvas();
    // 减去视口一半，使玩家在屏幕中心
    let targetX = worldX - canvas.width / 2;
    let targetY = worldY - canvas.height / 2;
    
    // 限制相机位置在地图边界内
    const clamped = this.clampCameraPosition(targetX, targetY);
    targetX = clamped.x;
    targetY = clamped.y;
    
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
    let targetX = worldX - canvas.width / 2;
    let targetY = worldY - canvas.height / 2;
    
    // 限制相机位置在地图边界内
    const clamped = this.clampCameraPosition(targetX, targetY);
    targetX = clamped.x;
    targetY = clamped.y;
    
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
          let expectedTargetX = worldX - canvas.width / 2;
          let expectedTargetY = worldY - canvas.height / 2;
          
          // 限制相机位置在地图边界内
          const clamped = this.clampCameraPosition(expectedTargetX, expectedTargetY);
          expectedTargetX = clamped.x;
          expectedTargetY = clamped.y;
          
          // 只有当玩家位置真正改变时才更新相机目标，避免不必要的更新导致抖动
          const targetDistance = Math.sqrt(
            Math.pow(this.cameraTargetX - expectedTargetX, 2) + 
            Math.pow(this.cameraTargetY - expectedTargetY, 2)
          );
          
          // 如果目标位置变化超过阈值（比如 5 像素），才更新相机目标
          if (targetDistance > 5) {
            this.setCameraTarget(expectedTargetX, expectedTargetY);
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

    // 确保相机位置在地图边界内（防止平滑跟随时超出边界）
    const clamped = this.clampCameraPosition(this.cameraX, this.cameraY);
    this.cameraX = clamped.x;
    this.cameraY = clamped.y;

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
    // 调试：统计玩家数量
    const playerCount = items.filter(item => item instanceof PlayerEntity).length;
    if (playerCount > 0 && Math.random() < 0.01) { // 每100帧打印一次，避免日志过多
      console.log(`SceneManager: Rendering ${playerCount} players, total items: ${items.length}`);
    }
    
    items.forEach(item => {
      this.renderItem(item);
    });

    // 在 WebGL 渲染完成后，使用 Canvas 2D 绘制玩家 UI（名称和血条）
    this.renderPlayerUIs(items);
  }

  private renderPlayerUIs(items: ISceneItem[]): void {
    // 清除之前的 UI 绘制
    this.uiContext.clearRect(0, 0, this.uiCanvas.width, this.uiCanvas.height);

    // 绘制所有玩家的 UI
    for (const item of items) {
      if (item instanceof PlayerEntity) {
        const worldX = item.getFloorX();
        const worldY = item.getFloorY();
        const screenX = worldX - this.cameraX;
        const screenY = worldY - this.cameraY;

        // 检查是否在视口内
        const canvas = this.renderer.getCanvas();
        const margin = 200;
        if (screenX + margin < 0 || screenX - margin > canvas.width ||
            screenY + margin < 0 || screenY - margin > canvas.height) {
          continue; // 不在视口内，跳过
        }

        const sprite = item.getSprite();
        const spriteWidth = sprite?.width || 64;
        const spriteHeight = sprite?.height || 64;
        this.renderPlayerInfo(item, screenX, screenY, spriteWidth, spriteHeight, this.uiContext);
      }
    }
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
    } else {
      // 调试：如果玩家没有 sprite，记录日志（但不要太频繁）
      if (Math.random() < 0.001) { // 每1000帧打印一次
        console.warn(`SceneManager: Player ${player.username} (ID: ${player.playerId}) has no sprite or texture, cannot render`);
      }
    }

    // 注意：玩家 UI 现在在 renderPlayerUIs 中统一渲染
  }

  private renderPlayerInfo(player: PlayerEntity, screenX: number, screenY: number, spriteWidth: number, spriteHeight: number, ctx: CanvasRenderingContext2D): void {
    // 计算玩家头部位置（sprite 中心上方）
    const playerCenterX = screenX + (spriteWidth / 2);
    // 在玩家头部上方留一点间距，根据 sprite 高度调整
    const playerTopY = screenY - (spriteHeight * 0.1) - 5;

    // 保存当前状态
    ctx.save();

    // 设置文字样式
    ctx.font = '12px Arial';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'top';
    ctx.fillStyle = '#ffffff';
    ctx.strokeStyle = '#000000';
    ctx.lineWidth = 2;

    // 绘制玩家名称（带描边）
    const nameY = playerTopY - 30;
    ctx.strokeText(player.username, playerCenterX, nameY);
    ctx.fillText(player.username, playerCenterX, nameY);

    // 绘制血条
    const barWidth = 60;
    const barHeight = 6;
    const barX = playerCenterX - barWidth / 2;
    const barY = nameY + 16;

    // 血条背景（深红色/黑色边框）
    ctx.fillStyle = '#000000';
    ctx.fillRect(barX - 1, barY - 1, barWidth + 2, barHeight + 2);

    // 血条背景（灰色）
    ctx.fillStyle = '#333333';
    ctx.fillRect(barX, barY, barWidth, barHeight);

    // 计算血量百分比
    const maxHp = 100; // 假设最大血量为 100
    const hpPercent = Math.max(0, Math.min(1, player.hp / maxHp));
    const hpWidth = barWidth * hpPercent;

    // 血条（红色）
    ctx.fillStyle = '#ff0000';
    ctx.fillRect(barX, barY, hpWidth, barHeight);

    // 血量文本（白色，在血条下方）
    ctx.font = '10px Arial';
    ctx.fillStyle = '#ffffff';
    ctx.strokeStyle = '#000000';
    ctx.lineWidth = 1.5;
    const hpText = `${Math.floor(player.hp)}/${maxHp}`;
    const hpTextY = barY + barHeight + 2;
    ctx.strokeText(hpText, playerCenterX, hpTextY);
    ctx.fillText(hpText, playerCenterX, hpTextY);

    // 恢复状态
    ctx.restore();
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

