import { ref, Ref, onMounted } from 'vue';
import { Game } from './core/Game';
import { WebSocketClient } from './network/WebSocketClient';
import { MessageHandler } from './network/MessageHandler';
import { Login } from './modules/login/Login';
import { Chat } from './modules/chat/Chat';
import { LoginAck, LoginReq, MessageType } from './network/Protocol';

const WS_SERVER_URL = 'ws://localhost:8887';

let gameInstance: Game | null = null;
let wsClientInstance: WebSocketClient | null = null;
let loginModuleInstance: Login | null = null;
let chatModuleInstance: Chat | null = null;

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
      try {
        await gameInstance.enterGame(mapId);

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
