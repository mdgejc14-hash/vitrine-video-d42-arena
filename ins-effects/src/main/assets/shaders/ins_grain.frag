#version 300 es
precision mediump float;
in vec2 vTexSamplingCoord;
out vec4 fragColor;

uniform sampler2D uTexSampler;
uniform float uGrainAmount;     // 0,015 a 0,030 (1,5 a 3 %)
uniform float uTimeSeed;        // change a CHAQUE image (sinon grain fige = voile statique)

float hash(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

void main() {
    vec4 tex = texture(uTexSampler, vTexSamplingCoord);
    float luma = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    float shadowWeight = 1.0 - smoothstep(0.0, 0.6, luma);
    float n = hash(vTexSamplingCoord * 1024.0 + uTimeSeed) - 0.5;
    float grain = n * uGrainAmount * (0.4 + 0.6 * shadowWeight);
    fragColor = vec4(clamp(tex.rgb + grain, 0.0, 1.0), tex.a);
}
