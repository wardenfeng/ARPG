import { AStar, PathPoint } from '../../pathfinding/AStar';
import { WebSocketClient } from '../../network/WebSocketClient';
import { MessageType, MoveReq } from '../../network/Protocol';
import { EventBus } from '../../core/EventBus';

export class MovementController {
  private astar: AStar | null = null;
  private currentPath: PathPoint[] = [];
  private currentPathIndex: number = 0;
  private wsClient: WebSocketClient | null = null;
  private eventBus: EventBus;

  constructor(eventBus: EventBus) {
    this.eventBus = eventBus;
  }

  setAStar(astar: AStar): void {
    this.astar = astar;
  }

  setWebSocketClient(wsClient: WebSocketClient): void {
    this.wsClient = wsClient;
  }

  findPath(startX: number, startY: number, endX: number, endY: number): PathPoint[] | null {
    if (!this.astar) {
      console.warn('A* not initialized');
      return null;
    }

    const path = this.astar.find(startX, startY, endX, endY);
    return path;
  }

  moveTo(mapX: number, mapY: number, currentMapX: number, currentMapY: number): void {
    if (!this.astar) {
      // Direct move without pathfinding
      this.sendMoveRequest(mapX, mapY);
      return;
    }

    const path = this.findPath(currentMapX, currentMapY, mapX, mapY);
    if (path && path.length > 0) {
      this.currentPath = path;
      this.currentPathIndex = 0;
      this.eventBus.emit('movement:pathFound', path);
    } else {
      console.warn('No path found');
    }
  }

  update(_deltaTime: number, currentMapX: number, currentMapY: number): { mapX: number; mapY: number } | null {
    if (this.currentPath.length === 0 || this.currentPathIndex >= this.currentPath.length) {
      return null;
    }

    const target = this.currentPath[this.currentPathIndex];
    const [targetMapX, targetMapY] = target;

    // Check if reached current target
    if (currentMapX === targetMapX && currentMapY === targetMapY) {
      this.currentPathIndex++;
      
      if (this.currentPathIndex >= this.currentPath.length) {
        // Reached final destination
        this.currentPath = [];
        this.currentPathIndex = 0;
        this.eventBus.emit('movement:arrived');
        return null;
      }

      // Move to next point in path
      const nextTarget = this.currentPath[this.currentPathIndex];
      this.sendMoveRequest(nextTarget[0], nextTarget[1]);
      return { mapX: nextTarget[0], mapY: nextTarget[1] };
    }

    return null;
  }

  private sendMoveRequest(mapX: number, mapY: number): void {
    if (!this.wsClient || !this.wsClient.isConnected()) {
      return;
    }

    const message: MoveReq = {
      type: MessageType.MOVE_REQ,
      mapX,
      mapY,
    };

    this.wsClient.send(message);
  }

  stop(): void {
    this.currentPath = [];
    this.currentPathIndex = 0;
  }

  hasPath(): boolean {
    return this.currentPath.length > 0;
  }

  hasAStar(): boolean {
    return this.astar !== null;
  }
}

