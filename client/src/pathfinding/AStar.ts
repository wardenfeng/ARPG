import { MapTileModel, PathType } from './MapTileModel';

export type PathPoint = [number, number];

export class AStar {
  private mapTileModel: MapTileModel;
  private maxTry: number;
  private isBalk: boolean = false;

  private readonly COST_HORIZONTAL = 10;
  private readonly COST_VERTICAL = 5;
  private readonly COST_DIAGONAL = 11;

  private openList: number[] = [];
  private openCount: number = 0;
  private openId: number = -1;

  private xList: number[] = [];
  private yList: number[] = [];
  private pathScoreList: number[] = [];
  private movementCostList: number[] = [];
  private fatherList: number[] = [];
  private noteMap: (number[] | null)[][] = [];

  constructor(mapTileModel: MapTileModel, maxTry: number = 600) {
    this.mapTileModel = mapTileModel;
    this.maxTry = maxTry;
  }

  find(startX: number, startY: number, endX: number, endY: number): PathPoint[] | null {
    console.log(`AStar.find: Finding path from (${startX}, ${startY}) to (${endX}, ${endY})`);
    const startTime = performance.now();
    this.initLists();
    this.openCount = 0;
    this.openId = -1;

    // 检查起点和终点是否可以通过
    // 根据 ActionScript 逻辑：只要不是 PATH_BARRIER (1)，就可以通过
    // PATH_PASS (0) 和 PATH_TRANSPARENT (2) 都可以通过
    const startBlock = this.mapTileModel.isBlock(0, 0, startX, startY);
    const endBlock = this.mapTileModel.isBlock(0, 0, endX, endY);
    console.log(`AStar.find: Start block type: ${startBlock}, End block type: ${endBlock}`);
    
    if (startBlock === PathType.BARRIER) {
      console.warn(`AStar.find: Start position (${startX}, ${startY}) is blocked (type: ${startBlock})`);
      return null;
    }
    if (endBlock === PathType.BARRIER) {
      console.warn(`AStar.find: End position (${endX}, ${endY}) is blocked (type: ${endBlock})`);
      return null;
    }

    this.openNote(startX, startY, 0, 0, -1);

    let currId: number;
    let currNoteX: number;
    let currNoteY: number;

    while (this.openCount > 0) {
      // Timeout check
      const currentTime = performance.now();
      if (currentTime - startTime > this.maxTry) {
        this.destroyLists();
        return null;
      }

      // Get node with lowest score from open list
      currId = this.openList[0];
      this.closeNote(currId);
      currNoteX = this.xList[currId];
      currNoteY = this.yList[currId];

      // Check if reached end
      if (currNoteX === endX && currNoteY === endY) {
        return this.getPath(startX, startY, currId);
      }

      // Get surrounding nodes
      const aroundNotes = this.getArounds(currNoteX, currNoteY);

      for (const note of aroundNotes) {
        const [noteX, noteY] = note;

        // Calculate cost
        let cost: number;
        if (currNoteY === noteY) {
          // Horizontal
          cost = this.movementCostList[currId] + this.COST_HORIZONTAL;
        } else if (currNoteX === noteX) {
          // Vertical
          cost = this.movementCostList[currId] + this.COST_VERTICAL;
        } else {
          // Diagonal
          cost = this.movementCostList[currId] + this.COST_DIAGONAL;
        }

        // Calculate heuristic (distance to end)
        const xDistance = Math.abs(endX - noteX) * this.COST_HORIZONTAL;
        const yDistance = Math.abs(endY - noteY) * this.COST_VERTICAL;
        const score = cost + Math.sqrt(xDistance * xDistance + yDistance * yDistance);

        if (this.isOpen(noteX, noteY)) {
          // Node already in open list
          const checkingId = this.noteMap[noteY]![noteX]![0];
          if (cost < this.movementCostList[checkingId]) {
            // Update with better path
            this.movementCostList[checkingId] = cost;
            this.pathScoreList[checkingId] = score;
            this.fatherList[checkingId] = currId;
            this.aheadNote(this.getIndex(checkingId));
          }
        } else {
          // Add to open list
          this.openNote(noteX, noteY, score, cost, currId);
        }
      }
    }

    // No path found
    this.destroyLists();
    return null;
  }

  private openNote(x: number, y: number, score: number, cost: number, fatherId: number): void {
    this.openCount++;
    this.openId++;

    if (!this.noteMap[y]) {
      this.noteMap[y] = [];
    }
    if (!this.noteMap[y]![x]) {
      this.noteMap[y]![x] = [];
    }
    this.noteMap[y]![x]![0] = this.openId; // ID
    this.noteMap[y]![x]![1] = 1; // OPEN flag

    this.xList.push(x);
    this.yList.push(y);
    this.pathScoreList.push(score);
    this.movementCostList.push(cost);
    this.fatherList.push(fatherId);

    this.openList.push(this.openId);
    this.aheadNote(this.openCount);
  }

  private closeNote(id: number): void {
    this.openCount--;
    const noteX = this.xList[id];
    const noteY = this.yList[id];
    
    if (this.noteMap[noteY] && this.noteMap[noteY]![noteX]) {
      this.noteMap[noteY]![noteX]![1] = 0; // Not open
      this.noteMap[noteY]![noteX]![2] = 1; // CLOSED flag
    }

    if (this.openCount <= 0) {
      this.openCount = 0;
      this.openList = [];
      return;
    }

    this.openList[0] = this.openList.pop()!;
    this.backNote();
  }

  private aheadNote(index: number): void {
    let currentIndex = index;
    while (currentIndex > 1) {
      const father = Math.floor(currentIndex / 2);
      if (this.getScore(currentIndex) < this.getScore(father)) {
        // Swap
        const temp = this.openList[currentIndex - 1];
        this.openList[currentIndex - 1] = this.openList[father - 1];
        this.openList[father - 1] = temp;
        currentIndex = father;
      } else {
        break;
      }
    }
  }

  private backNote(): void {
    let checkIndex = 1;
    while (true) {
      let tmp = checkIndex;
      if (2 * tmp <= this.openCount) {
        if (this.getScore(checkIndex) > this.getScore(2 * tmp)) {
          checkIndex = 2 * tmp;
        }
        if (2 * tmp + 1 <= this.openCount) {
          if (this.getScore(checkIndex) > this.getScore(2 * tmp + 1)) {
            checkIndex = 2 * tmp + 1;
          }
        }
      }
      if (tmp === checkIndex) {
        break;
      } else {
        const temp = this.openList[tmp - 1];
        this.openList[tmp - 1] = this.openList[checkIndex - 1];
        this.openList[checkIndex - 1] = temp;
      }
    }
  }

  private isOpen(x: number, y: number): boolean {
    if (!this.noteMap[y] || !this.noteMap[y]![x]) {
      return false;
    }
    return this.noteMap[y]![x]![1] === 1;
  }

  private isClosed(x: number, y: number): boolean {
    if (!this.noteMap[y] || !this.noteMap[y]![x]) {
      return false;
    }
    return this.noteMap[y]![x]![2] === 1;
  }

  private getArounds(x: number, y: number): number[][] {
    const arr: number[][] = [];
    let checkX: number;
    let checkY: number;

    // Right
    checkX = x + 1;
    checkY = y;
    if (this.canPass(x, y, checkX, checkY) && !this.isClosed(checkX, checkY)) {
      arr.push([checkX, checkY]);
    }

    // Left
    checkX = x - 1;
    checkY = y;
    if (this.canPass(x, y, checkX, checkY) && !this.isClosed(checkX, checkY)) {
      arr.push([checkX, checkY]);
    }

    // Up
    checkX = x;
    checkY = y - 1;
    if (this.canPass(x, y, checkX, checkY) && !this.isClosed(checkX, checkY)) {
      arr.push([checkX, checkY]);
    }

    // Down
    checkX = x;
    checkY = y + 1;
    if (this.canPass(x, y, checkX, checkY) && !this.isClosed(checkX, checkY)) {
      arr.push([checkX, checkY]);
    }

    // Diagonal directions
    // Right-Down
    checkX = x + 1;
    checkY = y + 1;
    if (this.canPass(x, y, checkX, checkY) && 
        this.canPass(x, y, x + 1, y) && 
        this.canPass(x, y, x, y + 1) &&
        !this.isClosed(checkX, checkY)) {
      arr.push([checkX, checkY]);
    }

    // Right-Up
    checkX = x + 1;
    checkY = y - 1;
    if (this.canPass(x, y, checkX, checkY) && 
        this.canPass(x, y, x + 1, y) && 
        this.canPass(x, y, x, y - 1) &&
        !this.isClosed(checkX, checkY)) {
      arr.push([checkX, checkY]);
    }

    // Left-Down
    checkX = x - 1;
    checkY = y + 1;
    if (this.canPass(x, y, checkX, checkY) && 
        this.canPass(x, y, x - 1, y) && 
        this.canPass(x, y, x, y + 1) &&
        !this.isClosed(checkX, checkY)) {
      arr.push([checkX, checkY]);
    }

    // Left-Up
    checkX = x - 1;
    checkY = y - 1;
    if (this.canPass(x, y, checkX, checkY) && 
        this.canPass(x, y, x - 1, y) && 
        this.canPass(x, y, x, y - 1) &&
        !this.isClosed(checkX, checkY)) {
      arr.push([checkX, checkY]);
    }

    return arr;
  }

  private canPass(startX: number, startY: number, endX: number, endY: number): boolean {
    if (this.isBalk) return true;
    return this.mapTileModel.isBlock(startX, startY, endX, endY) !== PathType.BARRIER;
  }

  private getPath(startX: number, startY: number, id: number): PathPoint[] {
    const arr: PathPoint[] = [];
    let noteX = this.xList[id];
    let noteY = this.yList[id];
    let currentId = id;

    while (noteX !== startX || noteY !== startY) {
      arr.unshift([noteX, noteY]);
      currentId = this.fatherList[currentId];
      if (currentId < 0) break;
      noteX = this.xList[currentId];
      noteY = this.yList[currentId];
    }
    arr.unshift([startX, startY]);
    this.destroyLists();
    return arr;
  }

  private getIndex(id: number): number {
    for (let i = 0; i < this.openList.length; i++) {
      if (this.openList[i] === id) {
        return i + 1;
      }
    }
    return -1;
  }

  private getScore(index: number): number {
    return this.pathScoreList[this.openList[index - 1]];
  }

  private initLists(): void {
    this.openList = [];
    this.xList = [];
    this.yList = [];
    this.pathScoreList = [];
    this.movementCostList = [];
    this.fatherList = [];
    this.noteMap = [];
  }

  private destroyLists(): void {
    this.openList = [];
    this.xList = [];
    this.yList = [];
    this.pathScoreList = [];
    this.movementCostList = [];
    this.fatherList = [];
    this.noteMap = [];
  }
}

