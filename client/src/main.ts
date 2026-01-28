import { createApp } from 'vue';
import App from './App.vue';
import { Game } from './core/Game';
import { WebSocketClient } from './network/WebSocketClient';
import { MessageHandler } from './network/MessageHandler';

// WebSocket 服务器地址
const WS_SERVER_URL = 'ws://localhost:8887';

// 获取 canvas 元素
const canvas = document.getElementById('game-canvas') as HTMLCanvasElement;
if (!canvas) {
  throw new Error('Canvas element not found');
}

// 初始化游戏（不加载地图）
const game = new Game(canvas);
game.init().catch(console.error);

// 将 game 实例挂载到 window，供 Vue 组件访问
(window as any).__game = game;

// 初始化事件总线和消息处理器
const eventBus = game.getEventBus();
const messageHandler = new MessageHandler(eventBus);

// 初始化 WebSocket 客户端
const wsClient = new WebSocketClient(WS_SERVER_URL, messageHandler);

// 将 wsClient 挂载到 window，供 Vue 组件访问
(window as any).__wsClient = wsClient;

// 创建并挂载 Vue 应用
const app = createApp(App);
app.mount('#app');

