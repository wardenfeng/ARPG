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
    // ActionScript 中：
    // - mapWidth = mapData.length（列数，201）
    // - mapHeight = mapData[0].length（行数，89）
    // - mapData[endX][endY]（列优先：第一维是列 X，第二维是行 Y）
    //
    // JSON 中：
    // - mapData.length = 89（行数）
    // - mapData[0].length = 201（列数）
    // - mapData 是行优先（第一维是行 Y，第二维是列 X）
    //
    // 因此，ActionScript 的 mapData[endX][endY] 对应 JSON 的 mapData[endY][endX]
    // 但是，如果 JSON 在转换时保持了 ActionScript 的列优先结构（转置），
    // 那么应该使用 mapData[endX][endY]
    //
    // 根据验证脚本：JSON 中 mapData.length = 89（行数），mapData[0].length = 201（列数）
    // 这意味着 JSON 是行优先的，应该使用 mapData[endY][endX]
    //
    // 但是，如果 (40, 70) 仍然被标记为障碍，可能是因为：
    // 1. JSON 在转换时被转置了（从列优先转成了行优先，或者相反）
    // 2. 或者应该使用 mapData[endX][endY] 来访问（如果 JSON 保持了列优先结构）
    //
    // 让我们尝试使用 mapData[endX][endY] 来访问，看看是否能解决问题
    
    const firstDimLength = this.mapData.length;
    const secondDimLength = this.mapData[0]?.length || 0;
    
    // 如果 firstDimLength == 201 且 secondDimLength == 89，那么是列优先，使用 mapData[endX][endY]
    // 如果 firstDimLength == 89 且 secondDimLength == 201，那么是行优先，使用 mapData[endY][endX]
    
    if (firstDimLength === 201 && secondDimLength === 89) {
      // 列优先：ActionScript 格式
      const mapWidth = firstDimLength; // 列数（X 维度）
      const mapHeight = secondDimLength; // 行数（Y 维度）
      
      if (endX < 0 || endX >= mapWidth || endY < 0 || endY >= mapHeight) {
        return PathType.BARRIER;
      }
      
      if (this.mapData[endX] != null && this.mapData[endX][endY] != null) {
        return this.mapData[endX][endY];
      }
    } else {
      // 行优先：JSON 格式（当前情况）
      const mapHeight = firstDimLength; // 行数（Y 维度）
      const mapWidth = secondDimLength; // 列数（X 维度）

      if (endX < 0 || endX >= mapWidth || endY < 0 || endY >= mapHeight) {
        return PathType.BARRIER;
      }

      if (this.mapData[endY] != null && this.mapData[endY][endX] != null) {
        return this.mapData[endY][endX];
      }
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

  /**
   * 查找最近的可通行位置
   * @param targetX 目标X坐标
   * @param targetY 目标Y坐标
   * @param maxRadius 最大搜索半径
   * @returns 最近的可通行位置，如果找不到则返回 null
   */
  findNearestPassable(targetX: number, targetY: number, maxRadius: number = 10): { x: number; y: number } | null {
    const firstDimLength = this.mapData.length;
    const secondDimLength = this.mapData[0]?.length || 0;
    
    let mapWidth: number;
    let mapHeight: number;
    let isColumnMajor: boolean;
    
    if (firstDimLength === 201 && secondDimLength === 89) {
      // 列优先
      mapWidth = firstDimLength;
      mapHeight = secondDimLength;
      isColumnMajor = true;
    } else {
      // 行优先
      mapHeight = firstDimLength;
      mapWidth = secondDimLength;
      isColumnMajor = false;
    }

    // 从目标位置开始，按半径递增搜索
    for (let radius = 0; radius <= maxRadius; radius++) {
      for (let dy = -radius; dy <= radius; dy++) {
        for (let dx = -radius; dx <= radius; dx++) {
          // 只检查当前半径的边界点
          if (Math.abs(dx) === radius || Math.abs(dy) === radius) {
            const checkX = targetX + dx;
            const checkY = targetY + dy;
            
            // 检查边界
            if (checkX < 0 || checkX >= mapWidth || checkY < 0 || checkY >= mapHeight) {
              continue;
            }
            
            // 检查是否可通行
            let value: number;
            if (isColumnMajor) {
              value = this.mapData[checkX]?.[checkY] ?? PathType.BARRIER;
            } else {
              value = this.mapData[checkY]?.[checkX] ?? PathType.BARRIER;
            }
            
            if (value === PathType.PASS || value === PathType.TRANSPARENT) {
              return { x: checkX, y: checkY };
            }
          }
        }
      }
    }
    
    return null;
  }

  getMapData(): number[][] {
    return this.mapData;
  }
}

