import { WebSocketServer } from './websocket/WebSocketServer';
import { MessageRouter } from './websocket/MessageRouter';
import { PlayerDB } from './database/PlayerDB';
import { MonsterDB } from './database/MonsterDB';
import { PlayerManager } from './managers/PlayerManager';
import { BroadcastManager } from './managers/BroadcastManager';
import { SkillManager } from './managers/SkillManager';
import { LoginHandler } from './handlers/LoginHandler';
import { MoveHandler } from './handlers/MoveHandler';
import { SkillHandler } from './handlers/SkillHandler';
import { ChatHandler } from './handlers/ChatHandler';
import { join } from 'path';

const PORT = 8887;
const DATA_DIR = join(process.cwd(), 'data');

async function startServer() {
  console.log('Starting ARPG Server...');

  // Initialize databases
  const playerDB = new PlayerDB(DATA_DIR);
  const monsterDB = new MonsterDB(DATA_DIR);
  await playerDB.init();
  await monsterDB.init();

  // Initialize managers
  const playerManager = new PlayerManager();
  
  // Create a temporary WebSocket server for initialization
  // We'll update it after creating the real one
  let wsServer: WebSocketServer;
  const broadcastManager = new BroadcastManager(playerManager, null as any);
  const skillManager = new SkillManager(playerManager, broadcastManager, null as any);

  // Initialize handlers (will be updated with wsServer)
  const loginHandler = new LoginHandler(playerDB, playerManager, broadcastManager, null as any);
  const moveHandler = new MoveHandler(playerManager, broadcastManager, null as any);
  const skillHandler = new SkillHandler(playerManager, broadcastManager, skillManager, null as any);
  const chatHandler = new ChatHandler(playerManager, broadcastManager, null as any);

  // Initialize message router
  const messageRouter = new MessageRouter(loginHandler, moveHandler, skillHandler, chatHandler);

  // Initialize WebSocket server
  wsServer = new WebSocketServer(PORT, messageRouter);

  // Update all references
  (broadcastManager as any).wsServer = wsServer;
  (skillManager as any).wsServer = wsServer;
  (loginHandler as any).wsServer = wsServer;
  (moveHandler as any).wsServer = wsServer;
  (skillHandler as any).wsServer = wsServer;
  (chatHandler as any).wsServer = wsServer;

  // Start server
  wsServer.start();

  console.log(`Server started on port ${PORT}`);
}

startServer().catch(console.error);

