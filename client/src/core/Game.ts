import { GameLoop } from './GameLoop';
import { EventBus } from './EventBus';
import { WebGLRenderer } from '../renderer/WebGLRenderer';
import { SpriteRenderer } from '../renderer/SpriteRenderer';
import { ResourceLoader } from './ResourceLoader';
import { SceneManager } from '../scene/SceneManager';

export class Game {
  private canvas: HTMLCanvasElement;
  private renderer: WebGLRenderer;
  private spriteRenderer: SpriteRenderer;
  private resourceLoader: ResourceLoader;
  private sceneManager: SceneManager;
  private gameLoop: GameLoop;
  private eventBus: EventBus;
  private initialized: boolean = false;

  constructor(canvas: HTMLCanvasElement) {
    this.canvas = canvas;
    this.eventBus = new EventBus();
    this.renderer = new WebGLRenderer(canvas);
    this.resourceLoader = new ResourceLoader(this.renderer.getContext());
    this.spriteRenderer = new SpriteRenderer(this.renderer);
    this.sceneManager = new SceneManager(this.renderer, this.spriteRenderer, this.resourceLoader);
    this.gameLoop = new GameLoop(this.update.bind(this), this.render.bind(this));
    
    this.setupCanvas();
  }

  private setupCanvas(): void {
    const resize = () => {
      this.canvas.width = window.innerWidth;
      this.canvas.height = window.innerHeight;
      this.renderer.resize(this.canvas.width, this.canvas.height);
    };
    
    resize();
    window.addEventListener('resize', resize);
  }

  /**
   * 初始化游戏基础系统（不加载地图）
   */
  async init(): Promise<void> {
    if (this.initialized) return;
    
    console.log('Initializing game systems...');
    
    // 启动游戏循环（但不加载地图，等待登录成功）
    this.gameLoop.start();
    this.initialized = true;
    console.log('Game systems initialized');
  }

  /**
   * 进入游戏场景（登录成功后调用）
   * @param mapId 地图ID
   * @param playerMapX 玩家地图X坐标（可选，如果提供则设置相机目标）
   * @param playerMapY 玩家地图Y坐标（可选，如果提供则设置相机目标）
   */
  async enterGame(mapId: number, playerMapX?: number, playerMapY?: number): Promise<void> {
    console.log(`Entering game scene, loading map ${mapId}...`);
    
    // Load map
    try {
      await this.sceneManager.getMapRenderer().loadMapFromJSON(mapId);
      console.log('Map loaded successfully');
      
      const mapConfig = this.sceneManager.getMapRenderer().getConfig();
      if (mapConfig) {
        if (playerMapX !== undefined && playerMapY !== undefined) {
          // 立即设置相机位置到玩家位置，不经过平滑跟随，使玩家立即显示在屏幕中心
          this.sceneManager.setCameraToPlayer(playerMapX, playerMapY);
          console.log(`Camera immediately set to player position from map coords (${playerMapX}, ${playerMapY})`);
        } else {
          // 如果没有提供玩家位置，设置相机位置为地图中心
          this.sceneManager.setCameraPosition(mapConfig.mapWidth / 2, mapConfig.mapHeight / 2);
        }
        
        // 初始化 A* 寻路（使用加载的地图配置）
        this.eventBus.emit('game:mapLoaded', mapConfig);
      }
    } catch (error) {
      console.error('Failed to load map:', error);
      throw error;
    }
    
    // Load initial resources if needed
    this.eventBus.emit('game:enter');
    console.log('Game scene entered');
  }

  getRenderer(): WebGLRenderer {
    return this.renderer;
  }

  getSpriteRenderer(): SpriteRenderer {
    return this.spriteRenderer;
  }

  getResourceLoader(): ResourceLoader {
    return this.resourceLoader;
  }

  getEventBus(): EventBus {
    return this.eventBus;
  }

  getSceneManager(): SceneManager {
    return this.sceneManager;
  }

  private update(deltaTime: number): void {
    // Update game logic
    this.sceneManager.update(deltaTime);
    this.eventBus.emit('update', deltaTime);
  }

  private render(): void {
    this.renderer.clear();
    // Render game objects
    this.sceneManager.render();
    this.eventBus.emit('render');
  }

  destroy(): void {
    this.gameLoop.stop();
    this.resourceLoader.clear();
    this.spriteRenderer.destroy();
    this.eventBus.clear();
  }
}

