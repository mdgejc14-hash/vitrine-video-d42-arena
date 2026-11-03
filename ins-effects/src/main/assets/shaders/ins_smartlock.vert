#version 300 es
in vec4 aPosition;
in vec2 aTexCoords;
out vec2 vTexSamplingCoord;
void main() {
    gl_Position = aPosition;
    vTexSamplingCoord = aTexCoords;
}
