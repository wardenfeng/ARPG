import { FileDB } from './FileDB';
import { Monster } from '../models/Monster';
import { MonsterConfig } from '../models/MonsterConfig';
import { join } from 'path';

interface MonstersData {
  monsters: Monster[];
  nextId: number;
}

interface MonsterConfigsData {
  configs: MonsterConfig[];
}

export class MonsterDB {
  private db: FileDB<MonstersData>;
  private configDb: FileDB<MonsterConfigsData>;
  private data: MonstersData | null = null;
  private configs: MonsterConfigsData | null = null;

  constructor(dataDir: string) {
    const monstersPath = join(dataDir, 'monsters.json');
    const configsPath = join(dataDir, 'monster_configs.json');
    this.db = new FileDB<MonstersData>(monstersPath);
    this.configDb = new FileDB<MonsterConfigsData>(configsPath);
  }

  async init(): Promise<void> {
    this.data = await this.db.load();
    if (!this.data.monsters) {
      this.data.monsters = [];
    }
    if (!this.data.nextId) {
      this.data.nextId = 1;
    }

    try {
      this.configs = await this.configDb.load();
      if (!this.configs.configs) {
        this.configs.configs = [];
      }
    } catch {
      this.configs = { configs: [] };
    }
  }

  async getMonster(id: number): Promise<Monster | null> {
    await this.ensureLoaded();
    return this.data!.monsters.find(m => m.id === id) || null;
  }

  async getMonstersByMap(mapId: number): Promise<Monster[]> {
    await this.ensureLoaded();
    return this.data!.monsters.filter(m => m.mapId === mapId);
  }

  async createMonster(typeId: number, mapX: number, mapY: number, mapId: number): Promise<Monster> {
    await this.ensureLoaded();
    
    const config = this.getMonsterConfig(typeId);
    const hp = config?.hp || 100;

    const monster: Monster = {
      id: this.data!.nextId++,
      typeId,
      mapX,
      mapY,
      mapId,
      hp,
    };

    this.data!.monsters.push(monster);
    await this.db.save();
    return monster;
  }

  async updateMonster(monster: Monster): Promise<void> {
    await this.ensureLoaded();
    const index = this.data!.monsters.findIndex(m => m.id === monster.id);
    if (index >= 0) {
      this.data!.monsters[index] = monster;
      await this.db.save();
    }
  }

  async removeMonster(id: number): Promise<void> {
    await this.ensureLoaded();
    this.data!.monsters = this.data!.monsters.filter(m => m.id !== id);
    await this.db.save();
  }

  getMonsterConfig(typeId: number): MonsterConfig | undefined {
    if (!this.configs) return undefined;
    return this.configs.configs.find(c => c.typeId === typeId);
  }

  private async ensureLoaded(): Promise<void> {
    if (this.data === null) {
      await this.init();
    }
  }
}

