import { WebSocket } from 'ws';
import { LoginReq, LoginAck, LoginResult, MessageType, AddPlayerNtf } from '../types/Protocol';
import { PlayerDB } from '../database/PlayerDB';
import { PlayerManager } from '../managers/PlayerManager';
import { BroadcastManager } from '../managers/BroadcastManager';
import { WebSocketServer } from '../websocket/WebSocketServer';

export class LoginHandler {
  private playerDB: PlayerDB;
  private playerManager: PlayerManager;
  private broadcastManager: BroadcastManager;
  private wsServer: WebSocketServer;

  constructor(
    playerDB: PlayerDB,
    playerManager: PlayerManager,
    broadcastManager: BroadcastManager,
    wsServer: WebSocketServer
  ) {
    this.playerDB = playerDB;
    this.playerManager = playerManager;
    this.broadcastManager = broadcastManager;
    this.wsServer = wsServer;
  }

  async handle(ws: WebSocket, message: LoginReq): Promise<void> {
    const { account, password } = message;

    try {
      let player = await this.playerDB.getPlayerByUsername(account);

      if (!player) {
        // Auto-register if player doesn't exist
        player = await this.playerDB.createPlayer(account, password);
      } else if (player.password !== password) {
        // Password mismatch
        const ack: LoginAck = {
          type: MessageType.LOGIN_ACK,
          result: LoginResult.PASSWORD_ERROR,
        };
        this.wsServer.sendToClient(ws, ack);
        return;
      }

      // Login successful
      const clientId = this.wsServer.getClientId(ws);
      if (clientId) {
        this.playerManager.addPlayer(clientId, player);
      }

      const ack: LoginAck = {
        type: MessageType.LOGIN_ACK,
        result: LoginResult.SUCCEED,
        username: player.username,
        mapX: player.mapX,
        mapY: player.mapY,
        playerId: player.id,
        clothing: player.clothing,
        mapId: player.mapId,
        HP: player.hp,
        MP: player.mp,
      };
      this.wsServer.sendToClient(ws, ack);

      // Send existing players in the same map
      const otherPlayers = this.playerManager.getPlayersInMap(player.mapId, player.id);
      if (otherPlayers.length > 0) {
        const addPlayerNtf: AddPlayerNtf = {
          type: MessageType.ADD_PLAYER_NTF,
          addPlayer: otherPlayers.map(p => ({
            playerId: p.id,
            mapX: p.mapX,
            mapY: p.mapY,
            username: p.username,
            clothing: p.clothing,
            HP: p.hp,
            MP: p.mp,
          })),
        };
        this.wsServer.sendToClient(ws, addPlayerNtf);
      }

      // Notify other players about new player
      this.broadcastManager.addPlayer(player.mapId, player, player.id);
    } catch (error) {
      console.error('Login error:', error);
      const ack: LoginAck = {
        type: MessageType.LOGIN_ACK,
        result: LoginResult.FAIL,
      };
      this.wsServer.sendToClient(ws, ack);
    }
  }

  handleDisconnect(ws: WebSocket): void {
    const clientId = this.wsServer.getClientId(ws);
    if (clientId) {
      const player = this.playerManager.getPlayerByClientId(clientId);
      if (player) {
        this.playerManager.removePlayer(clientId);
        this.broadcastManager.removePlayer(player.mapId, player.id);
        // Save player data
        this.playerDB.updatePlayer(player).catch(console.error);
      }
    }
  }
}

