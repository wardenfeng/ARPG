export enum PathType {
  PASS = 0,        // 可以通过
  BARRIER = 1,     // 障碍
  TRANSPARENT = 2, // 透明
}

export class MapTileModel {
  private mapData: number[][];

  constructor(mapData: number[][]) {
    this.mapData = mapData;
  }

  /**
   * 检查是否为障碍
   * @param _startX 起点X坐标（未使用，保留接口兼容性）
   * @param _startY 起点Y坐标（未使用，保留接口兼容性）
   * @param endX 终点X坐标
   * @param endY 终点Y坐标
   * @returns 路径类型
   */
  isBlock(_startX: number, _startY: number, endX: number, endY: number): number {
    const mapWidth = this.mapData.length;
    const mapHeight = this.mapData[0]?.length || 0;

    if (endX < 0 || endX >= mapWidth || endY < 0 || endY >= mapHeight) {
      return PathType.BARRIER;
    }

    if (this.mapData[endX] != null && this.mapData[endX][endY] != null) {
      return this.mapData[endX][endY];
    }

    return PathType.BARRIER;
  }

  /**
   * 真实坐标转格子坐标
   */
  static gridCoordinate(x: number, y: number, tileWidth: number, tileHeight: number): { x: number; y: number } {
    const gridX = Math.floor((x + tileWidth / 2) / tileWidth);
    const gridY = Math.floor((y + tileHeight / 2) / tileHeight);
    return { x: gridX, y: gridY };
  }

  /**
   * 格子坐标转真实坐标
   */
  static realCoordinate(x: number, y: number, tileWidth: number, tileHeight: number): { x: number; y: number } {
    const realX = tileWidth * x;
    const realY = tileHeight * y;
    return { x: realX, y: realY };
  }

  getMapData(): number[][] {
    return this.mapData;
  }
}

