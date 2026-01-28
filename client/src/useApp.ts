import { ref, Ref, onMounted } from 'vue';
import { Game } from './core/Game';
import { WebSocketClient } from './network/WebSocketClient';
import { MessageHandler } from './network/MessageHandler';
import { Login } from './modules/login/Login';
import { Chat } from './modules/chat/Chat';
import { PlayerManager } from './modules/player/PlayerManager';
import { MovementController } from './modules/movement/MovementController';
import { ClickMovement } from './modules/movement/ClickMovement';
import { AStar } from './pathfinding/AStar';
import { MapTileModel, PathType } from './pathfinding/MapTileModel';
import { MapConfig } from './scene/MapRenderer';
import { LoginAck, LoginReq, MessageType } from './network/Protocol';
import { PlayerEntity } from './scene/entities/PlayerEntity';
import { Sprite } from './renderer/Sprite';
import { SpriteSheet } from './animation/SpriteSheet';
import { PlayerAnimation, ActionType, Direction, PlayerAnimationConfig } from './animation/PlayerAnimation';
import { Texture } from './renderer/Texture';

const WS_SERVER_URL = 'ws://localhost:8887';

let gameInstance: Game | null = null;
let wsClientInstance: WebSocketClient | null = null;
let loginModuleInstance: Login | null = null;
let chatModuleInstance: Chat | null = null;
let playerManagerInstance: PlayerManager | null = null;
let movementControllerInstance: MovementController | null = null;
let clickMovementInstance: ClickMovement | null = null;

export function useApp() {
  const isLoggedIn: Ref<boolean> = ref(false);
  const errorMessage: Ref<string> = ref('');

  const initGame = (): void => {
    const gameCanvas = document.getElementById('game-canvas') as HTMLCanvasElement;
    if (!gameCanvas) {
      throw new Error('Canvas element not found');
    }

    gameInstance = new Game(gameCanvas);
    gameInstance.init().catch(console.error);

    // 将 game 实例挂载到 window，供其他模块访问
    (window as any).__game = gameInstance;

    // 初始化事件总线和消息处理器
    const eventBus = gameInstance.getEventBus();
    const messageHandler = new MessageHandler(eventBus);

    // 初始化 WebSocket 客户端
    wsClientInstance = new WebSocketClient(WS_SERVER_URL, messageHandler);
    (window as any).__wsClient = wsClientInstance;

    // 初始化登录模块
    loginModuleInstance = new Login(eventBus);
    loginModuleInstance.setWebSocketClient(wsClientInstance);
    loginModuleInstance.setOnLoginSuccess(handleLoginSuccess);

    // 初始化聊天模块
    chatModuleInstance = new Chat();
    chatModuleInstance.setWebSocketClient(wsClientInstance);

    // 初始化玩家管理模块
    playerManagerInstance = new PlayerManager(eventBus);
    playerManagerInstance.setSceneManager(gameInstance.getSceneManager());

    // 初始化移动控制器
    movementControllerInstance = new MovementController(eventBus);
    movementControllerInstance.setWebSocketClient(wsClientInstance);
    (window as any).__movementController = movementControllerInstance;

    // 初始化点击移动
    const clickCanvas = document.getElementById('game-canvas') as HTMLCanvasElement;
    if (clickCanvas) {
      clickMovementInstance = new ClickMovement(clickCanvas, eventBus);
    }

    // 监听聊天发送事件
    eventBus.on('chat:send', (message: string) => {
      if (chatModuleInstance) {
        chatModuleInstance.sendMessage(message);
      }
    });

    // 监听地图点击事件，进行寻路和移动
    eventBus.on('click:map', (data: { x: number; y: number }) => {
      handleMapClick(data.x, data.y);
    });

    // 监听地图加载完成事件，初始化 A* 寻路
    eventBus.on('game:mapLoaded', (mapConfig: MapConfig) => {
      initializePathfinding(mapConfig);
    });
  };

  const initializePathfinding = (mapConfig: MapConfig): void => {
    if (!movementControllerInstance) {
      console.warn('MovementController not initialized, cannot initialize pathfinding');
      return;
    }

    const mapData = mapConfig.mapData;
    if (mapData) {
      console.log(`Initializing A* with map data: ${mapData.length} rows, first row length: ${mapData[0]?.length}`);
      const mapTileModel = new MapTileModel(mapData);
      const astar = new AStar(mapTileModel);
      movementControllerInstance.setAStar(astar);
      console.log('A* pathfinding initialized successfully');
    } else {
      console.warn('Map data not available, cannot initialize A*');
    }
  };

  const handleMapClick = (screenX: number, screenY: number): void => {
    if (!gameInstance || !movementControllerInstance || !clickMovementInstance) {
      return;
    }

    const sceneManager = gameInstance.getSceneManager();
    const mapRenderer = sceneManager.getMapRenderer();
    const config = mapRenderer.getConfig();
    
    if (!config) {
      console.warn('Map config not available, cannot handle click');
      return;
    }

    // 获取当前玩家
    const currentPlayerId = (window as any).__currentPlayerId;
    if (currentPlayerId === undefined) {
      return;
    }

    const items = sceneManager.getScene().getItems();
    let currentPlayer: PlayerEntity | null = null;
    for (const item of items) {
      if (item instanceof PlayerEntity && item.playerId === currentPlayerId) {
        currentPlayer = item;
        break;
      }
    }

    if (!currentPlayer) {
      console.warn('Current player not found');
      return;
    }

    // 获取相机位置
    const cameraX = sceneManager.getCameraX();
    const cameraY = sceneManager.getCameraY();

    // 将屏幕坐标转换为世界坐标
    const worldX = screenX + cameraX;
    const worldY = screenY + cameraY;

    // 将世界坐标转换为地图坐标
    const mapX = Math.floor(worldX / config.walkGridWidth);
    const mapY = Math.floor(worldY / config.walkGridHeight);

    // 获取当前玩家位置
    const currentMapX = currentPlayer.getMapX();
    const currentMapY = currentPlayer.getMapY();

    console.log(`Click at screen (${screenX}, ${screenY}), world (${worldX}, ${worldY}), map (${mapX}, ${mapY})`);
    console.log(`Current player at map (${currentMapX}, ${currentMapY})`);

    // 如果点击位置和当前位置相同，不处理
    if (mapX === currentMapX && mapY === currentMapY) {
      console.log('Click position same as current position, ignoring');
      return;
    }

    // 检查坐标是否在地图范围内
    if (mapX < 0 || mapX >= config.walkGridColumns || mapY < 0 || mapY >= config.walkGridRows) {
      console.warn(`Click position (${mapX}, ${mapY}) is out of map bounds (${config.walkGridColumns}x${config.walkGridRows})`);
      return;
    }

    // 检查 A* 是否已初始化（应该在进入场景时初始化）
    if (!movementControllerInstance.hasAStar()) {
      console.warn('A* not initialized, initializing now...');
      const mapData = config.mapData;
      if (mapData) {
        console.log(`Initializing A* with map data: ${mapData.length} rows, first row length: ${mapData[0]?.length}`);
        const mapTileModel = new MapTileModel(mapData);
        const astar = new AStar(mapTileModel);
        movementControllerInstance.setAStar(astar);
      } else {
        console.warn('Map data not available, cannot initialize A*');
        return;
      }
    }

    // 检查目标位置是否可通行
    const mapTileModel = new MapTileModel(config.mapData);
    const targetBlock = mapTileModel.isBlock(0, 0, mapX, mapY);
    
    let finalMapX = mapX;
    let finalMapY = mapY;
    
    if (targetBlock === PathType.BARRIER) {
      console.warn(`Target position (${mapX}, ${mapY}) is blocked, finding nearest passable position...`);
      const nearestPassable = mapTileModel.findNearestPassable(mapX, mapY, 10);
      if (nearestPassable) {
        finalMapX = nearestPassable.x;
        finalMapY = nearestPassable.y;
        console.log(`Found nearest passable position: (${finalMapX}, ${finalMapY})`);
      } else {
        console.warn(`No passable position found near (${mapX}, ${mapY})`);
        return;
      }
    }

    // 使用 A* 寻路并开始移动
    console.log(`Finding path from (${currentMapX}, ${currentMapY}) to (${finalMapX}, ${finalMapY})`);
    movementControllerInstance.moveTo(finalMapX, finalMapY, currentMapX, currentMapY);
  };

  const handleLogin = async (account: string, password: string): Promise<void> => {
    if (!loginModuleInstance || !wsClientInstance) {
      errorMessage.value = '系统未初始化';
      return;
    }

    errorMessage.value = '';

    // 确保 WebSocket 已连接
    if (!wsClientInstance.isConnected()) {
      try {
        await wsClientInstance.connect();
      } catch (error) {
        console.error('Failed to connect:', error);
        errorMessage.value = '连接服务器失败';
        return;
      }
    }

    // 发送登录请求
    const message: LoginReq = {
      type: MessageType.LOGIN_REQ,
      account,
      password,
    };
    wsClientInstance.send(message);
  };

  const handleLoginSuccess = async (loginAck: LoginAck): Promise<void> => {
    console.log('Login successful, entering game...', loginAck);
    isLoggedIn.value = true;

    // 登录成功后进入游戏场景
    if (gameInstance) {
      const mapId = loginAck.mapId || 1001;
      const playerMapX = loginAck.mapX;
      const playerMapY = loginAck.mapY;
      try {
        // 传入玩家位置，使相机跟随玩家
        await gameInstance.enterGame(mapId, playerMapX, playerMapY);

        // 保存当前玩家ID，用于后续相机跟随
        if (loginAck.playerId !== undefined) {
          (window as any).__currentPlayerId = loginAck.playerId;
        }

        // 创建当前玩家实体（服务器不会在 ADD_PLAYER_NTF 中包含当前玩家）
        if (playerManagerInstance && loginAck.playerId !== undefined && playerMapX !== undefined && playerMapY !== undefined) {
          const sceneManager = gameInstance.getSceneManager();
          const mapRenderer = sceneManager.getMapRenderer();
          const config = mapRenderer.getConfig();
          if (config) {
            // 创建当前玩家实体
            const currentPlayer = new PlayerEntity(
              loginAck.playerId,
              loginAck.username || 'Player',
              playerMapX,
              playerMapY
            );
            currentPlayer.setMapPosition(playerMapX, playerMapY, config.walkGridWidth, config.walkGridHeight);
            currentPlayer.hp = loginAck.HP || 100;
            currentPlayer.mp = loginAck.MP || 50;

            // 创建占位符 sprite 和动画（使用 PlayerManager 的方法）
            // 由于 PlayerManager 的 setupPlayerSprite 是私有的，我们需要直接创建
            const game = (window as any).__game;
            if (game && game.getResourceLoader()) {
              const gl = game.getRenderer().getContext();
              
              // 创建占位符纹理
              const canvas = document.createElement('canvas');
              canvas.width = 64;
              canvas.height = 64;
              const ctx = canvas.getContext('2d');
              if (ctx) {
                ctx.fillStyle = '#4caf50';
                ctx.fillRect(0, 0, 64, 64);
                ctx.strokeStyle = '#2e7d32';
                ctx.lineWidth = 2;
                ctx.strokeRect(2, 2, 60, 60);
                ctx.fillStyle = '#ffffff';
                ctx.beginPath();
                ctx.arc(32, 20, 10, 0, Math.PI * 2);
                ctx.fill();
              }
              const image = new Image();
              image.src = canvas.toDataURL();
              await image.decode();
              const texture = new Texture(gl);
              await texture.loadFromImage(image);
              
              const sprite = new Sprite(texture);
              sprite.width = 64;
              sprite.height = 64;
              currentPlayer.setSprite(sprite);

              const spriteSheet = new SpriteSheet({
                image: '',
                frameWidth: 64,
                frameHeight: 64,
                columns: 1,
                rows: 1,
              });

              const animationConfig: PlayerAnimationConfig = {
                actions: {
                  [ActionType.STAND]: { frames: '0', speed: 1 },
                  [ActionType.WALK]: { frames: '0', speed: 1 },
                },
                directions: [Direction.DOWN, Direction.LEFT, Direction.UP, Direction.RIGHT],
              };

              const animation = new PlayerAnimation(spriteSheet, animationConfig);
              animation.setAction(ActionType.STAND);
              animation.setDirection(Direction.DOWN);
              currentPlayer.setAnimation(animation);
            }

            // 添加到场景
            sceneManager.addItem(currentPlayer);
            console.log(`Created current player entity: ${loginAck.username} (ID: ${loginAck.playerId}) at (${playerMapX}, ${playerMapY})`);
          }
        }

        // 聊天界面由 Vue 组件自动显示，无需手动调用
      } catch (error) {
        console.error('Failed to enter game:', error);
        errorMessage.value = '进入游戏失败，请刷新页面重试';
        isLoggedIn.value = false;
      }
    }
  };

  // 自动初始化游戏
  onMounted(() => {
    initGame();
  });

  return {
    isLoggedIn,
    errorMessage,
    handleLogin,
  };
}
