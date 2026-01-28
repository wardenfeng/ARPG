import { Texture } from '../renderer/Texture';

export class ResourceLoader {
  private textures: Map<string, Texture> = new Map();
  private gl: WebGLRenderingContext;

  constructor(gl: WebGLRenderingContext) {
    this.gl = gl;
  }

  async loadTexture(name: string, url: string): Promise<Texture> {
    if (this.textures.has(name)) {
      return this.textures.get(name)!;
    }

    const texture = new Texture(this.gl);
    await texture.loadFromUrl(url);
    this.textures.set(name, texture);
    return texture;
  }

  getTexture(name: string): Texture | undefined {
    return this.textures.get(name);
  }

  async loadImage(url: string): Promise<HTMLImageElement> {
    return new Promise((resolve, reject) => {
      const image = new Image();
      image.crossOrigin = 'anonymous';
      image.onload = () => resolve(image);
      image.onerror = () => reject(new Error(`Failed to load image: ${url}`));
      image.src = url;
    });
  }

  async loadJSON<T>(url: string): Promise<T> {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`Failed to load JSON: ${url}`);
    }
    return response.json();
  }

  clear(): void {
    this.textures.forEach(texture => texture.destroy());
    this.textures.clear();
  }
}

