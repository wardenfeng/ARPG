attribute vec2 a_position;
attribute vec2 a_texCoord;

uniform mat3 u_matrix;

varying vec2 v_texCoord;

void main() {
  vec3 position = u_matrix * vec3(a_position, 1.0);
  gl_Position = vec4(position.xy, 0.0, 1.0);
  v_texCoord = a_texCoord;
}

