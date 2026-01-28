import { ref, Ref, onMounted } from 'vue';
import { Game } from './core/Game';
import { WebSocketClient } from './network/WebSocketClient';
import { MessageHandler } from './network/MessageHandler';
import { Login } from './modules/login/Login';
import { Chat } from './modules/chat/Chat';
import { PlayerManager } from './modules/player/PlayerManager';
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

export function useApp() {
  const isLoggedIn: Ref<boolean> = ref(false);
  const errorMessage: Ref<string> = ref('');

  const initGame = (): void => {
    const canvas = document.getElementById('game-canvas') as HTMLCanvasElement;
    if (!canvas) {
      throw new Error('Canvas element not found');
    }

    gameInstance = new Game(canvas);
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

    // 监听聊天发送事件
    eventBus.on('chat:send', (message: string) => {
      if (chatModuleInstance) {
        chatModuleInstance.sendMessage(message);
      }
    });
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
