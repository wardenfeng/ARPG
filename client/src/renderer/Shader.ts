export class Shader {
  private gl: WebGLRenderingContext;
  private program: WebGLProgram | null = null;

  constructor(gl: WebGLRenderingContext, vertexSource: string, fragmentSource: string) {
    this.gl = gl;
    this.program = this.createProgram(vertexSource, fragmentSource);
  }

  private createProgram(vertexSource: string, fragmentSource: string): WebGLProgram {
    const vertexShader = this.compileShader(this.gl.VERTEX_SHADER, vertexSource);
    const fragmentShader = this.compileShader(this.gl.FRAGMENT_SHADER, fragmentSource);

    const program = this.gl.createProgram();
    if (!program) {
      throw new Error('Failed to create shader program');
    }

    this.gl.attachShader(program, vertexShader);
    this.gl.attachShader(program, fragmentShader);
    this.gl.linkProgram(program);

    if (!this.gl.getProgramParameter(program, this.gl.LINK_STATUS)) {
      const info = this.gl.getProgramInfoLog(program);
      this.gl.deleteProgram(program);
      throw new Error(`Failed to link shader program: ${info}`);
    }

    return program;
  }

  private compileShader(type: number, source: string): WebGLShader {
    const shader = this.gl.createShader(type);
    if (!shader) {
      throw new Error('Failed to create shader');
    }

    this.gl.shaderSource(shader, source);
    this.gl.compileShader(shader);

    if (!this.gl.getShaderParameter(shader, this.gl.COMPILE_STATUS)) {
      const info = this.gl.getShaderInfoLog(shader);
      this.gl.deleteShader(shader);
      throw new Error(`Failed to compile shader: ${info}`);
    }

    return shader;
  }

  use(): void {
    if (this.program) {
      this.gl.useProgram(this.program);
    }
  }

  getProgram(): WebGLProgram | null {
    return this.program;
  }

  getAttributeLocation(name: string): number {
    if (!this.program) return -1;
    return this.gl.getAttribLocation(this.program, name);
  }

  getUniformLocation(name: string): WebGLUniformLocation | null {
    if (!this.program) return null;
    return this.gl.getUniformLocation(this.program, name);
  }

  destroy(): void {
    if (this.program) {
      this.gl.deleteProgram(this.program);
      this.program = null;
    }
  }
}

