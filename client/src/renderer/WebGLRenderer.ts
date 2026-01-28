export class WebGLRenderer {
  private gl: WebGLRenderingContext;
  private canvas: HTMLCanvasElement;

  constructor(canvas: HTMLCanvasElement) {
    this.canvas = canvas;
    const gl = canvas.getContext('webgl') || canvas.getContext('experimental-webgl');
    
    if (!gl) {
      throw new Error('WebGL is not supported in this browser');
    }

    this.gl = gl as WebGLRenderingContext;
    this.setupCanvas();
  }

  private setupCanvas(): void {
    const gl = this.gl;
    
    // Set viewport
    gl.viewport(0, 0, this.canvas.width, this.canvas.height);
    
    // Enable blending for transparency
    gl.enable(gl.BLEND);
    gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
    
    // Set clear color
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
  }

  getContext(): WebGLRenderingContext {
    return this.gl;
  }

  getCanvas(): HTMLCanvasElement {
    return this.canvas;
  }

  clear(): void {
    this.gl.clear(this.gl.COLOR_BUFFER_BIT);
  }

  resize(width: number, height: number): void {
    this.canvas.width = width;
    this.canvas.height = height;
    this.gl.viewport(0, 0, width, height);
  }
}

