export class Texture {
  private gl: WebGLRenderingContext;
  private texture: WebGLTexture | null = null;
  private width: number = 0;
  private height: number = 0;

  constructor(gl: WebGLRenderingContext) {
    this.gl = gl;
  }

  async loadFromImage(image: HTMLImageElement): Promise<void> {
    return new Promise((resolve, reject) => {
      if (image.complete) {
        this.createTexture(image);
        resolve();
      } else {
        image.onload = () => {
          this.createTexture(image);
          resolve();
        };
        image.onerror = () => reject(new Error('Failed to load image'));
      }
    });
  }

  async loadFromUrl(url: string): Promise<void> {
    const image = new Image();
    image.crossOrigin = 'anonymous';
    
    return new Promise((resolve, reject) => {
      image.onload = () => {
        this.createTexture(image);
        resolve();
      };
      image.onerror = () => reject(new Error(`Failed to load image from ${url}`));
      image.src = url;
    });
  }

  private createTexture(image: HTMLImageElement): void {
    const gl = this.gl;
    
    this.texture = gl.createTexture();
    if (!this.texture) {
      throw new Error('Failed to create texture');
    }

    this.width = image.width;
    this.height = image.height;

    gl.bindTexture(gl.TEXTURE_2D, this.texture);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image);
    
    // Set texture parameters
    if (this.isPowerOf2(image.width) && this.isPowerOf2(image.height)) {
      gl.generateMipmap(gl.TEXTURE_2D);
    } else {
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    }

    gl.bindTexture(gl.TEXTURE_2D, null);
  }

  private isPowerOf2(value: number): boolean {
    return (value & (value - 1)) === 0;
  }

  bind(unit: number = 0): void {
    if (this.texture) {
      const gl = this.gl;
      gl.activeTexture(gl.TEXTURE0 + unit);
      gl.bindTexture(gl.TEXTURE_2D, this.texture);
    }
  }

  unbind(): void {
    this.gl.bindTexture(this.gl.TEXTURE_2D, null);
  }

  getWidth(): number {
    return this.width;
  }

  getHeight(): number {
    return this.height;
  }

  destroy(): void {
    if (this.texture) {
      this.gl.deleteTexture(this.texture);
      this.texture = null;
    }
  }
}

