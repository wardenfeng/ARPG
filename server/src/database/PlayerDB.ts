import { FileDB } from './FileDB';
import { Player } from '../models/Player';
import { join } from 'path';

interface PlayersData {
  players: Player[];
  nextId: number;
}

export class PlayerDB {
  private db: FileDB<PlayersData>;
  private data: PlayersData | null = null;

  constructor(dataDir: string) {
    const filePath = join(dataDir, 'players.json');
    this.db = new FileDB<PlayersData>(filePath);
  }

  async init(): Promise<void> {
    this.data = await this.db.load();
    if (!this.data.players) {
      this.data.players = [];
    }
    if (!this.data.nextId) {
      this.data.nextId = 1;
    }
  }

  async getPlayer(id: number): Promise<Player | null> {
    await this.ensureLoaded();
    return this.data!.players.find(p => p.id === id) || null;
  }

  async getPlayerByUsername(username: string): Promise<Player | null> {
    await this.ensureLoaded();
    return this.data!.players.find(p => p.username === username) || null;
  }

  async createPlayer(username: string, password: string): Promise<Player> {
    await this.ensureLoaded();
    
    const player: Player = {
      id: this.data!.nextId++,
      username,
      password, // In production, this should be hashed
      // 设置默认出生位置（根据 SQL 数据，玩家默认位置为 (39, 69)，但该位置可能是障碍，改为 (38, 63)）
      mapX: 38,
      mapY: 63,
      clothing: '10002',
      mapId: 1001,
      hp: 100,
      mp: 50,
    };

    this.data!.players.push(player);
    await this.db.save();
    return player;
  }

  async updatePlayer(player: Player): Promise<void> {
    await this.ensureLoaded();
    const index = this.data!.players.findIndex(p => p.id === player.id);
    if (index >= 0) {
      this.data!.players[index] = player;
      await this.db.save();
    }
  }

  async getAllPlayers(): Promise<Player[]> {
    await this.ensureLoaded();
    return [...this.data!.players];
  }

  private async ensureLoaded(): Promise<void> {
    if (this.data === null) {
      await this.init();
    }
  }
}

