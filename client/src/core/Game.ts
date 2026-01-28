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

  async init(): Promise<void> {
    if (this.initialized) return;
    
    console.log('Initializing game...');
    
    // Load initial map
    try {
      await this.sceneManager.getMapRenderer().loadMapFromJSON(1001);
      console.log('Map loaded successfully');
    } catch (error) {
      console.error('Failed to load map:', error);
    }
    
    // Load initial resources if needed
    this.eventBus.emit('game:init');
    
    this.gameLoop.start();
    this.initialized = true;
    console.log('Game initialized');
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

