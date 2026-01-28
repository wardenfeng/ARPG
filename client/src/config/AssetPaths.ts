/**
 * 资源路径配置
 * Vite 会将 public 目录中的文件作为静态资源提供，路径以 / 开头
 */
export const AssetPaths = {
  /**
   * 获取地图瓦片路径
   * @param mapId 地图ID
   * @param tileX 瓦片X坐标
   * @param tileY 瓦片Y坐标
   * @returns 瓦片图片路径
   */
  getMapTilePath(mapId: number, tileX: number, tileY: number): string {
    return `/assets/scene/${mapId}/${tileX}_${tileY}.jpg`;
  },

  /**
   * 获取地图配置路径
   * @param mapId 地图ID
   * @returns 地图配置JSON路径
   */
  getMapConfigPath(mapId: number): string {
    return `/assets/scene/${mapId}/config.json`;
  },

  /**
   * 获取玩家资源路径
   * @param resourceName 资源名称（如 clothing/10002）
   * @returns 资源路径
   */
  getPlayerResourcePath(resourceName: string): string {
    return `/assets/resources/player/${resourceName}.swf`;
  },

  /**
   * 获取NPC资源路径
   * @param npcId NPC ID
   * @returns NPC资源路径
   */
  getNPCResourcePath(npcId: number): string {
    return `/assets/resources/npc/${npcId}.swf`;
  },

  /**
   * 获取怪物资源路径
   * @param monsterId 怪物ID
   * @returns 怪物资源路径
   */
  getMonsterResourcePath(monsterId: number): string {
    return `/assets/resources/enemy/${monsterId}.swf`;
  },

  /**
   * 获取特效资源路径
   * @param effectName 特效名称
   * @returns 特效资源路径
   */
  getEffectResourcePath(effectName: string): string {
    return `/assets/resources/effect/${effectName}.swf`;
  },

  /**
   * 获取音乐资源路径
   * @param musicName 音乐名称
   * @returns 音乐资源路径
   */
  getMusicResourcePath(musicName: string): string {
    return `/assets/resources/music/${musicName}.mp3`;
  },

  /**
   * 获取游戏数据资源路径
   * @param dataName 数据名称（如 mapdata, model）
   * @returns 数据资源路径
   */
  getGameDataResourcePath(dataName: string): string {
    return `/assets/resources/gamedata/${dataName}.swf`;
  },
};

