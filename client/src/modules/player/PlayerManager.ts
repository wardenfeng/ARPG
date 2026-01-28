import { EventBus } from '../../core/EventBus';
import { SceneManager } from '../../scene/SceneManager';
import { PlayerEntity } from '../../scene/entities/PlayerEntity';
import { AddPlayerNtf, RemovePlayerNtf } from '../../network/Protocol';

export class PlayerManager {
  private eventBus: EventBus;
  private sceneManager: SceneManager | null = null;
  private players: Map<number, PlayerEntity> = new Map();

  constructor(eventBus: EventBus) {
    this.eventBus = eventBus;
    this.setupListeners();
  }

  setSceneManager(sceneManager: SceneManager): void {
    this.sceneManager = sceneManager;
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

      // 添加到场景
      this.sceneManager.addItem(playerEntity);
      this.players.set(playerData.playerId, playerEntity);

      console.log(`PlayerManager: Added player ${playerData.username} (ID: ${playerData.playerId}) at (${playerData.mapX}, ${playerData.mapY})`);
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

