import { Texture } from './Texture';

export class Sprite {
  public x: number = 0;
  public y: number = 0;
  public width: number = 0;
  public height: number = 0;
  public texture: Texture | null = null;
  public u0: number = 0; // Texture coordinate (left)
  public v0: number = 0; // Texture coordinate (top)
  public u1: number = 1; // Texture coordinate (right)
  public v1: number = 1; // Texture coordinate (bottom)

  constructor(texture?: Texture) {
    if (texture) {
      this.texture = texture;
      this.width = texture.getWidth();
      this.height = texture.getHeight();
    }
  }

  setTexture(texture: Texture): void {
    this.texture = texture;
    this.width = texture.getWidth();
    this.height = texture.getHeight();
  }

  setTextureCoords(u0: number, v0: number, u1: number, v1: number): void {
    this.u0 = u0;
    this.v0 = v0;
    this.u1 = u1;
    this.v1 = v1;
  }
}

