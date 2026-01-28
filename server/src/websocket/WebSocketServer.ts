import { WebSocket, WebSocketServer as WSServer } from 'ws';
import { GameMessage, Protocol, MessageType } from '../types/Protocol';
import { MessageRouter } from './MessageRouter';

export class WebSocketServer {
  private wss: WSServer | null = null;
  private port: number;
  private clients: Map<WebSocket, { id: number }> = new Map();
  private nextClientId: number = 1;
  private messageRouter: MessageRouter;

  constructor(port: number, messageRouter: MessageRouter) {
    this.port = port;
    this.messageRouter = messageRouter;
  }

  start(): void {
    this.wss = new WSServer({ port: this.port });

    this.wss.on('connection', (ws: WebSocket) => {
      const clientId = this.nextClientId++;
      this.clients.set(ws, { id: clientId });
      
      console.log(`Client ${clientId} connected`);

      ws.on('message', (data: Buffer) => {
        try {
          const message = Protocol.deserialize(data.toString());
          this.handleMessage(ws, message);
        } catch (error) {
          console.error('Error parsing message:', error);
        }
      });

      ws.on('close', () => {
        console.log(`Client ${clientId} disconnected`);
        this.messageRouter.handleDisconnect(ws);
        this.clients.delete(ws);
      });

      ws.on('error', (error) => {
        console.error(`Client ${clientId} error:`, error);
      });
    });

    console.log(`WebSocket server listening on port ${this.port}`);
  }

  private handleMessage(ws: WebSocket, message: GameMessage): void {
    this.messageRouter.route(ws, message);
  }

  broadcast(message: GameMessage, excludeClient?: WebSocket): void {
    const data = Protocol.serialize(message);
    this.clients.forEach((client, ws) => {
      if (ws !== excludeClient && ws.readyState === WebSocket.OPEN) {
        ws.send(data);
      }
    });
  }

  sendToClient(ws: WebSocket, message: GameMessage): void {
    if (ws.readyState === WebSocket.OPEN) {
      ws.send(Protocol.serialize(message));
    }
  }

  getClientId(ws: WebSocket): number | undefined {
    return this.clients.get(ws)?.id;
  }

  getAllClients(): WebSocket[] {
    return Array.from(this.clients.keys());
  }

  stop(): void {
    if (this.wss) {
      this.wss.close();
      this.wss = null;
    }
  }
}

