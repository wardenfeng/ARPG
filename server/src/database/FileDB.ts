import { promises as fs } from 'fs';
import { join } from 'path';

export class FileDB<T> {
  private filePath: string;
  private data: T | null = null;
  private writeQueue: Promise<void> = Promise.resolve();

  constructor(filePath: string) {
    this.filePath = filePath;
  }

  async load(): Promise<T> {
    try {
      const data = await fs.readFile(this.filePath, 'utf-8');
      this.data = JSON.parse(data) as T;
      return this.data;
    } catch (error: any) {
      if (error.code === 'ENOENT') {
        // File doesn't exist, create empty data
        this.data = {} as T;
        await this.save();
        return this.data;
      }
      throw error;
    }
  }

  async save(): Promise<void> {
    if (this.data === null) {
      await this.load();
    }

    // Queue writes to prevent concurrent write issues
    this.writeQueue = this.writeQueue.then(async () => {
      const dir = join(this.filePath, '..');
      await fs.mkdir(dir, { recursive: true });
      await fs.writeFile(this.filePath, JSON.stringify(this.data, null, 2), 'utf-8');
    });

    return this.writeQueue;
  }

  getData(): T | null {
    return this.data;
  }

  setData(data: T): void {
    this.data = data;
  }

  async ensureLoaded(): Promise<void> {
    if (this.data === null) {
      await this.load();
    }
  }
}

