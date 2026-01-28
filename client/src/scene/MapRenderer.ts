import { WebGLRenderer } from '../renderer/WebGLRenderer';
import { SpriteRenderer } from '../renderer/SpriteRenderer';
import { Texture } from '../renderer/Texture';
import { Sprite } from '../renderer/Sprite';
import { ResourceLoader } from '../core/ResourceLoader';
import { AssetPaths } from '../config/AssetPaths';

export interface MapConfig {
  mapId: number;
  mapWidth: number;
  mapHeight: number;
  // 渲染瓦片配置（用于显示地图图片）
  renderTileWidth: number;  // 300 像素
  renderTileHeight: number; // 300 像素
  renderTileRows: number;   // 17 个
  renderTileColumns: number; // 15 个
  // 行走网格配置（用于路径查找）
  walkGridWidth: number;    // 50 像素
  walkGridHeight: number;  // 25 像素
  walkGridRows: number;     // 89 行
  walkGridColumns: number;  // 201 列
  mapData: number[][];      // 89x201 的行走网格数据
}

export class MapRenderer {
  private spriteRenderer: SpriteRenderer;
  private resourceLoader: ResourceLoader;
  private config: MapConfig | null = null;
  private loadedTiles: Map<string, Texture> = new Map();
  private tileSprites: Map<string, Sprite> = new Map();
  private cameraX: number = 0;
  private cameraY: number = 0;
  private viewWidth: number = 0;
  private viewHeight: number = 0;

  constructor(_renderer: WebGLRenderer, spriteRenderer: SpriteRenderer, resourceLoader: ResourceLoader) {
    this.spriteRenderer = spriteRenderer;
    this.resourceLoader = resourceLoader;
  }

  /**
   * 从 MapConfig 对象加载地图
   */
  async loadMap(config: MapConfig): Promise<void> {
    this.config = config;
    // Set initial camera position to center of map
    if (this.viewWidth === 0 || this.viewHeight === 0) {
      // If viewport not set, use default
      this.viewWidth = 800;
      this.viewHeight = 600;
    }
    // Preload visible tiles
    await this.preloadVisibleTiles();
  }

  /**
   * 从 JSON 文件加载地图配置
   * 严格按照 ActionScript 的 GlobalData.as 和 config.as 进行转换
   */
  async loadMapFromJSON(mapId: number): Promise<void> {
    console.log(`Loading map ${mapId} from JSON...`);
    const configUrl = AssetPaths.getMapConfigPath(mapId);
    console.log(`Config URL: ${configUrl}`);
    
    const jsonConfig = await this.resourceLoader.loadJSON<any>(configUrl);
    console.log('Map config loaded:', jsonConfig);
    
    // 严格按照 ActionScript 代码进行转换：
    // 1. GlobalData.as 中定义：MapTileWidth = 300, MapTileHeight = 300
    // 2. config.as 中定义：TILE_WIDTH = 50, TILE_HEIGHT = 25, Row = 89, Col = 201
    // 3. 渲染瓦片的数量根据地图尺寸计算：Math.ceil(mapWidth / MapTileWidth) 和 Math.ceil(mapHeight / MapTileHeight)
    
    const mapWidth = jsonConfig.mapWidth || 0;
    const mapHeight = jsonConfig.mapHeight || 0;
    
    // 渲染瓦片配置（来自 GlobalData.as）
    const RENDER_TILE_WIDTH = 300;  // GlobalData.MapTileWidth
    const RENDER_TILE_HEIGHT = 300; // GlobalData.MapTileHeight
    // 渲染瓦片数量根据地图尺寸计算（参考 GameSceneBackground.as 的计算方式）
    const renderTileColumns = Math.ceil(mapWidth / RENDER_TILE_WIDTH);
    const renderTileRows = Math.ceil(mapHeight / RENDER_TILE_HEIGHT);
    
    // 行走网格配置（来自 config.as，对应 JSON 中的 tileWidth/tileHeight/rows/columns）
    const walkGridWidth = jsonConfig.tileWidth || 50;   // config.TILE_WIDTH
    const walkGridHeight = jsonConfig.tileHeight || 25; // config.TILE_HEIGHT
    const walkGridRows = jsonConfig.rows || 89;         // config.Row
    const walkGridColumns = jsonConfig.columns || 201;  // config.Col
    
    const config: MapConfig = {
      mapId: jsonConfig.mapId || mapId,
      mapWidth: mapWidth,
      mapHeight: mapHeight,
      // 渲染瓦片配置（从 GlobalData.as 转换）
      renderTileWidth: RENDER_TILE_WIDTH,
      renderTileHeight: RENDER_TILE_HEIGHT,
      renderTileRows: renderTileRows,
      renderTileColumns: renderTileColumns,
      // 行走网格配置（从 config.as 转换，对应 JSON 字段）
      walkGridWidth: walkGridWidth,
      walkGridHeight: walkGridHeight,
      walkGridRows: walkGridRows,
      walkGridColumns: walkGridColumns,
      mapData: jsonConfig.mapData,
    };
    
    console.log(`Map config: Render tiles ${config.renderTileColumns}x${config.renderTileRows} (${config.renderTileWidth}x${config.renderTileHeight}), Walk grid ${config.walkGridColumns}x${config.walkGridRows} (${config.walkGridWidth}x${config.walkGridHeight})`);
    
    await this.loadMap(config);
    console.log('Map loaded, tiles loaded:', this.tileSprites.size);
  }

  private async preloadVisibleTiles(): Promise<void> {
    if (!this.config) return;

    // 使用渲染瓦片的尺寸来计算需要加载哪些瓦片
    const startX = Math.floor(this.cameraX / this.config.renderTileWidth);
    const startY = Math.floor(this.cameraY / this.config.renderTileHeight);
    const endX = Math.ceil((this.cameraX + this.viewWidth) / this.config.renderTileWidth);
    const endY = Math.ceil((this.cameraY + this.viewHeight) / this.config.renderTileHeight);

    const loadPromises: Promise<void>[] = [];

    for (let x = startX; x < endX; x++) {
      for (let y = startY; y < endY; y++) {
        // 检查是否在渲染瓦片的范围内
        if (x >= 0 && y >= 0 && x < this.config.renderTileColumns && y < this.config.renderTileRows) {
          const tileKey = `${x}_${y}`;
          // 只加载尚未尝试加载的瓦片（包括加载失败的）
          if (!this.loadedTiles.has(tileKey)) {
            const url = AssetPaths.getMapTilePath(this.config.mapId, x, y);
            loadPromises.push(this.loadTile(tileKey, url));
          }
        }
      }
    }

    await Promise.all(loadPromises);
  }

  private async loadTile(key: string, url: string): Promise<void> {
    try {
      const texture = await this.resourceLoader.loadTexture(key, url);
      this.loadedTiles.set(key, texture);
      
      const sprite = new Sprite(texture);
      // 设置纹理坐标为整个纹理 (0,0 到 1,1)
      sprite.setTextureCoords(0, 0, 1, 1);
      // 设置瓦片尺寸（使用渲染瓦片的尺寸）
      if (this.config) {
        sprite.width = this.config.renderTileWidth;
        sprite.height = this.config.renderTileHeight;
      }
      this.tileSprites.set(key, sprite);
    } catch (error) {
      // 某些瓦片文件可能不存在，这是正常的（例如地图边界外的瓦片或未生成的瓦片）
      // 静默处理，不显示错误（避免控制台噪音）
      // 标记为已尝试加载，避免重复尝试
      this.loadedTiles.set(key, null as any);
    }
  }

  setCamera(x: number, y: number, width: number, height: number): void {
    this.cameraX = x;
    this.cameraY = y;
    this.viewWidth = width;
    this.viewHeight = height;
    
    // Load new tiles if needed
    if (this.config) {
      this.preloadVisibleTiles().catch(console.error);
    }
  }

  render(): void {
    if (!this.config) {
      return;
    }

    // 使用渲染瓦片的尺寸来计算需要渲染哪些瓦片
    const startX = Math.floor(this.cameraX / this.config.renderTileWidth);
    const startY = Math.floor(this.cameraY / this.config.renderTileHeight);
    const endX = Math.ceil((this.cameraX + this.viewWidth) / this.config.renderTileWidth);
    const endY = Math.ceil((this.cameraY + this.viewHeight) / this.config.renderTileHeight);

    let renderedCount = 0;
    for (let x = startX; x < endX; x++) {
      for (let y = startY; y < endY; y++) {
        // 检查是否在渲染瓦片的范围内
        if (x >= 0 && y >= 0 && x < this.config.renderTileColumns && y < this.config.renderTileRows) {
          const tileKey = `${x}_${y}`;
          const sprite = this.tileSprites.get(tileKey);
          
          // 只渲染已成功加载的瓦片（sprite 存在且 texture 不为 null）
          if (sprite && sprite.texture) {
            const tileX = x * this.config.renderTileWidth;
            const tileY = y * this.config.renderTileHeight;
            const screenX = tileX - this.cameraX;
            const screenY = tileY - this.cameraY;
            
            // 只渲染在视口内的瓦片
            if (screenX + this.config.renderTileWidth >= 0 && screenX < this.viewWidth &&
                screenY + this.config.renderTileHeight >= 0 && screenY < this.viewHeight) {
              this.spriteRenderer.render(sprite, screenX, screenY);
              renderedCount++;
            }
          }
          // 如果瓦片不存在，跳过渲染（这是正常的，因为某些瓦片文件可能不存在）
        }
      }
    }
    
    // Debug: log render info occasionally
    if (Math.random() < 0.01) {
      console.log(`Rendered ${renderedCount} tiles, camera: (${this.cameraX}, ${this.cameraY}), viewport: ${this.viewWidth}x${this.viewHeight}`);
    }
  }

  getConfig(): MapConfig | null {
    return this.config;
  }

  /**
   * 获取行走网格的宽度（用于路径查找）
   */
  getWalkGridWidth(): number {
    return this.config ? this.config.walkGridWidth : 50;
  }

  /**
   * 获取行走网格的高度（用于路径查找）
   */
  getWalkGridHeight(): number {
    return this.config ? this.config.walkGridHeight : 25;
  }

  /**
   * 获取渲染瓦片的宽度（用于显示）
   */
  getRenderTileWidth(): number {
    return this.config ? this.config.renderTileWidth : 300;
  }

  /**
   * 获取渲染瓦片的高度（用于显示）
   */
  getRenderTileHeight(): number {
    return this.config ? this.config.renderTileHeight : 300;
  }

  /**
   * 获取地图数据（行走网格数据，用于路径查找）
   */
  getMapData(): number[][] | null {
    return this.config ? this.config.mapData : null;
  }

  /**
   * 获取当前视野宽度（游戏世界坐标）
   */
  getViewWidth(): number {
    return this.viewWidth;
  }

  /**
   * 获取当前视野高度（游戏世界坐标）
   */
  getViewHeight(): number {
    return this.viewHeight;
  }

  /**
   * 获取当前相机位置
   */
  getCameraX(): number {
    return this.cameraX;
  }

  /**
   * 获取当前相机位置
   */
  getCameraY(): number {
    return this.cameraY;
  }
}

