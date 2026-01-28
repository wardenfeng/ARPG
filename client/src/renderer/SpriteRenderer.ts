import { WebGLRenderer } from './WebGLRenderer';
import { Shader } from './Shader';
import { Sprite } from './Sprite';
import { Texture } from './Texture';

const VERTEX_SHADER = `
attribute vec2 a_position;
attribute vec2 a_texCoord;

uniform mat3 u_matrix;

varying vec2 v_texCoord;

void main() {
  vec3 position = u_matrix * vec3(a_position, 1.0);
  gl_Position = vec4(position.xy, 0.0, 1.0);
  v_texCoord = a_texCoord;
}
`;

const FRAGMENT_SHADER = `
precision mediump float;

uniform sampler2D u_texture;
uniform float u_alpha;

varying vec2 v_texCoord;

void main() {
  vec4 color = texture2D(u_texture, v_texCoord);
  gl_FragColor = vec4(color.rgb, color.a * u_alpha);
}
`;

export class SpriteRenderer {
  private renderer: WebGLRenderer;
  private shader: Shader;
  private positionBuffer: WebGLBuffer | null = null;
  private texCoordBuffer: WebGLBuffer | null = null;
  private indexBuffer: WebGLBuffer | null = null;

  constructor(renderer: WebGLRenderer) {
    this.renderer = renderer;
    const gl = renderer.getContext();
    
    this.shader = new Shader(gl, VERTEX_SHADER, FRAGMENT_SHADER);
    this.setupBuffers();
  }

  private setupBuffers(): void {
    const gl = this.renderer.getContext();

    // Position buffer (quad vertices)
    this.positionBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, this.positionBuffer);
    const positions = new Float32Array([
      0, 0,
      1, 0,
      0, 1,
      1, 1,
    ]);
    gl.bufferData(gl.ARRAY_BUFFER, positions, gl.STATIC_DRAW);

    // Index buffer
    this.indexBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
    const indices = new Uint16Array([
      0, 1, 2,
      2, 1, 3,
    ]);
    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, indices, gl.STATIC_DRAW);

    // Texture coordinate buffer
    this.texCoordBuffer = gl.createBuffer();
  }

  render(sprite: Sprite, x: number, y: number, width?: number, height?: number): void {
    if (!sprite.texture) return;

    const gl = this.renderer.getContext();
    const canvas = this.renderer.getCanvas();

    // Use shader
    this.shader.use();

    // Set up texture
    sprite.texture.bind(0);
    const textureLocation = this.shader.getUniformLocation('u_texture');
    if (textureLocation) {
      gl.uniform1i(textureLocation, 0);
    }

    // Set alpha
    const alphaLocation = this.shader.getUniformLocation('u_alpha');
    if (alphaLocation) {
      gl.uniform1f(alphaLocation, 1.0);
    }

    // Calculate dimensions
    const w = width || sprite.width;
    const h = height || sprite.height;

    // Create transformation matrix (orthographic projection)
    const matrix = this.createMatrix(x, y, w, h, canvas.width, canvas.height);
    const matrixLocation = this.shader.getUniformLocation('u_matrix');
    if (matrixLocation) {
      gl.uniformMatrix3fv(matrixLocation, false, matrix);
    }

    // Set up position attribute
    const positionLocation = this.shader.getAttributeLocation('a_position');
    if (positionLocation >= 0) {
      gl.bindBuffer(gl.ARRAY_BUFFER, this.positionBuffer);
      gl.enableVertexAttribArray(positionLocation);
      gl.vertexAttribPointer(positionLocation, 2, gl.FLOAT, false, 0, 0);
    }

    // Set up texture coordinate attribute
    const texCoordLocation = this.shader.getAttributeLocation('a_texCoord');
    if (texCoordLocation >= 0) {
      gl.bindBuffer(gl.ARRAY_BUFFER, this.texCoordBuffer);
      const texCoords = new Float32Array([
        sprite.u0, sprite.v0,
        sprite.u1, sprite.v0,
        sprite.u0, sprite.v1,
        sprite.u1, sprite.v1,
      ]);
      gl.bufferData(gl.ARRAY_BUFFER, texCoords, gl.DYNAMIC_DRAW);
      gl.enableVertexAttribArray(texCoordLocation);
      gl.vertexAttribPointer(texCoordLocation, 2, gl.FLOAT, false, 0, 0);
    }

    // Draw
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
    gl.drawElements(gl.TRIANGLES, 6, gl.UNSIGNED_SHORT, 0);
  }

  private createMatrix(x: number, y: number, width: number, height: number, canvasWidth: number, canvasHeight: number): Float32Array {
    // Convert to normalized device coordinates
    const scaleX = 2 / canvasWidth;
    const scaleY = -2 / canvasHeight; // Flip Y axis
    const translateX = -1;
    const translateY = 1;

    // Transformation matrix (column-major order)
    return new Float32Array([
      width * scaleX, 0, 0,
      0, height * scaleY, 0,
      x * scaleX + translateX, y * scaleY + translateY, 1,
    ]);
  }

  destroy(): void {
    const gl = this.renderer.getContext();
    
    if (this.positionBuffer) {
      gl.deleteBuffer(this.positionBuffer);
    }
    if (this.texCoordBuffer) {
      gl.deleteBuffer(this.texCoordBuffer);
    }
    if (this.indexBuffer) {
      gl.deleteBuffer(this.indexBuffer);
    }
    
    this.shader.destroy();
  }
}

