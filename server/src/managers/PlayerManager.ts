import { Player } from '../models/Player';

export class PlayerManager {
  private clientPlayerMap: Map<number, Player> = new Map(); // clientId -> Player
  private playerClientMap: Map<number, number> = new Map(); // playerId -> clientId
  private mapPlayersMap: Map<number, Set<number>> = new Map(); // mapId -> Set<playerId>

  addPlayer(clientId: number, player: Player): void {
    this.clientPlayerMap.set(clientId, player);
    this.playerClientMap.set(player.id, clientId);
    
    if (!this.mapPlayersMap.has(player.mapId)) {
      this.mapPlayersMap.set(player.mapId, new Set());
    }
    this.mapPlayersMap.get(player.mapId)!.add(player.id);
  }

  removePlayer(clientId: number): void {
    const player = this.clientPlayerMap.get(clientId);
    if (player) {
      this.clientPlayerMap.delete(clientId);
      this.playerClientMap.delete(player.id);
      const mapPlayers = this.mapPlayersMap.get(player.mapId);
      if (mapPlayers) {
        mapPlayers.delete(player.id);
      }
    }
  }

  getPlayerByClientId(clientId: number): Player | undefined {
    return this.clientPlayerMap.get(clientId);
  }

  getPlayerByPlayerId(playerId: number): Player | undefined {
    const clientId = this.playerClientMap.get(playerId);
    if (clientId) {
      return this.clientPlayerMap.get(clientId);
    }
    return undefined;
  }

  getPlayersInMap(mapId: number, excludePlayerId?: number): Player[] {
    const playerIds = this.mapPlayersMap.get(mapId);
    if (!playerIds) {
      return [];
    }

    const players: Player[] = [];
    for (const playerId of playerIds) {
      if (playerId !== excludePlayerId) {
        const player = this.getPlayerByPlayerId(playerId);
        if (player) {
          players.push(player);
        }
      }
    }
    return players;
  }

  getAllPlayers(): Player[] {
    return Array.from(this.clientPlayerMap.values());
  }
}

