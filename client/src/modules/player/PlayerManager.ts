import { EventBus } from '../../core/EventBus';
import { SceneManager } from '../../scene/SceneManager';
import { PlayerEntity } from '../../scene/entities/PlayerEntity';
import { AddPlayerNtf, RemovePlayerNtf } from '../../network/Protocol';
import { Sprite } from '../../renderer/Sprite';
import { Texture } from '../../renderer/Texture';
import { ResourceLoader } from '../../core/ResourceLoader';
import { SpriteSheet } from '../../animation/SpriteSheet';
import { PlayerAnimation, ActionType, Direction, PlayerAnimationConfig } from '../../animation/PlayerAnimation';

export class PlayerManager {
  private eventBus: EventBus;
  private sceneManager: SceneManager | null = null;
  private resourceLoader: ResourceLoader | null = null;
  private players: Map<number, PlayerEntity> = new Map();
  private placeholderTexture: Texture | null = null;

  constructor(eventBus: EventBus) {
    this.eventBus = eventBus;
    this.setupListeners();
  }

  setSceneManager(sceneManager: SceneManager): void {
    this.sceneManager = sceneManager;
    // 获取 ResourceLoader
    const game = (window as any).__game;
    if (game) {
      this.resourceLoader = game.getResourceLoader();
      this.createPlaceholderTexture();
    }
  }

  private async createPlaceholderTexture(): Promise<void> {
    if (!this.resourceLoader) return;

    try {
      // 创建一个简单的占位符纹理（1x1 像素的白色图片）
      const canvas = document.createElement('canvas');
      canvas.width = 64;
      canvas.height = 64;
      const ctx = canvas.getContext('2d');
      if (ctx) {
        // 绘制一个简单的玩家占位符（矩形）
        ctx.fillStyle = '#4caf50'; // 绿色
        ctx.fillRect(0, 0, 64, 64);
        ctx.strokeStyle = '#2e7d32';
        ctx.lineWidth = 2;
        ctx.strokeRect(2, 2, 60, 60);
        // 绘制一个简单的头部
        ctx.fillStyle = '#ffffff';
        ctx.beginPath();
        ctx.arc(32, 20, 10, 0, Math.PI * 2);
        ctx.fill();
      }

      // 将 canvas 转换为图片并创建纹理
      const image = new Image();
      image.src = canvas.toDataURL();
      await image.decode();

      // 获取 WebGL context
      const game = (window as any).__game;
      if (!game) {
        console.warn('PlayerManager: Game instance not found');
        return;
      }
      const gl = game.getRenderer().getContext();
      const texture = new Texture(gl);
      await texture.loadFromImage(image);
      this.placeholderTexture = texture;
    } catch (error) {
      console.error('Failed to create placeholder texture:', error);
    }
  }

  private setupListeners(): void {
    // 监听添加玩家事件
    this.eventBus.on('player:add', (message: AddPlayerNtf) => {
      this.handleAddPlayers(message);
    });

    // 监听移除玩家事件
    this.eventBus.on('player:remove', (message: RemovePlayerNtf) => {
      this.handleRemovePlayer(message);
    });
  }

  private handleAddPlayers(message: AddPlayerNtf): void {
    console.log('PlayerManager: Received ADD_PLAYER_NTF', message);
    
    if (!this.sceneManager) {
      console.warn('PlayerManager: SceneManager not set, cannot add players');
      return;
    }

    const mapRenderer = this.sceneManager.getMapRenderer();
    if (!mapRenderer) {
      console.warn('PlayerManager: MapRenderer not available, cannot add players');
      return;
    }

    const config = mapRenderer.getConfig();
    if (!config) {
      console.warn('PlayerManager: Map config not available, cannot add players');
      return;
    }

    // 获取瓦片尺寸
    const tileWidth = config.renderTileWidth;
    const tileHeight = config.renderTileHeight;

    // 添加每个玩家
    for (const playerData of message.addPlayer) {
      // 检查是否已存在
      if (this.players.has(playerData.playerId)) {
        console.log(`PlayerManager: Player ${playerData.playerId} already exists, updating position`);
        const existingPlayer = this.players.get(playerData.playerId)!;
        existingPlayer.setMapPosition(playerData.mapX, playerData.mapY, tileWidth, tileHeight);
        continue;
      }

      // 创建新玩家实体
      const playerEntity = new PlayerEntity(
        playerData.playerId,
        playerData.username,
        playerData.mapX,
        playerData.mapY
      );

      // 设置玩家位置
      playerEntity.setMapPosition(playerData.mapX, playerData.mapY, tileWidth, tileHeight);
      playerEntity.hp = playerData.HP;
      playerEntity.mp = playerData.MP;

      // 创建占位符 sprite 和动画
      this.setupPlayerSprite(playerEntity, playerData.clothing);

      // 添加到场景
      this.sceneManager.addItem(playerEntity);
      this.players.set(playerData.playerId, playerEntity);

      console.log(`PlayerManager: Added player ${playerData.username} (ID: ${playerData.playerId}) at (${playerData.mapX}, ${playerData.mapY})`);
    }
  }

  private async setupPlayerSprite(player: PlayerEntity, clothing: string): Promise<void> {
    // 使用占位符纹理创建 sprite
    if (this.placeholderTexture) {
      const sprite = new Sprite(this.placeholderTexture);
      sprite.width = 64;
      sprite.height = 64;
      player.setSprite(sprite);

      // 创建简单的动画配置（使用占位符）
      const spriteSheet = new SpriteSheet({
        image: '', // 占位符不需要实际的图片路径
        frameWidth: 64,
        frameHeight: 64,
        columns: 1,
        rows: 1,
      });

      // 创建简单的动画配置
      const animationConfig: PlayerAnimationConfig = {
        actions: {
          [ActionType.STAND]: {
            frames: '0',
            speed: 1,
          },
          [ActionType.WALK]: {
            frames: '0',
            speed: 1,
          },
        },
        directions: [Direction.DOWN, Direction.LEFT, Direction.UP, Direction.RIGHT],
      };

      const animation = new PlayerAnimation(spriteSheet, animationConfig);
      animation.setAction(ActionType.STAND);
      animation.setDirection(Direction.DOWN);
      player.setAnimation(animation);
    } else {
      // 如果占位符纹理还没创建，延迟设置
      setTimeout(() => {
        this.setupPlayerSprite(player, clothing);
      }, 100);
    }
  }

  private handleRemovePlayer(message: RemovePlayerNtf): void {
    console.log('PlayerManager: Received REMOVE_PLAYER_NTF', message);
    
    if (!this.sceneManager) {
      console.warn('PlayerManager: SceneManager not set, cannot remove player');
      return;
    }

    const player = this.players.get(message.playerId);
    if (player) {
      this.sceneManager.removeItem(player);
      this.players.delete(message.playerId);
      console.log(`PlayerManager: Removed player ${message.playerId}`);
    } else {
      console.warn(`PlayerManager: Player ${message.playerId} not found`);
    }
  }

  getPlayer(playerId: number): PlayerEntity | undefined {
    return this.players.get(playerId);
  }

  getAllPlayers(): PlayerEntity[] {
    return Array.from(this.players.values());
  }

  clear(): void {
    if (this.sceneManager) {
      for (const player of this.players.values()) {
        this.sceneManager.removeItem(player);
      }
    }
    this.players.clear();
  }
}

