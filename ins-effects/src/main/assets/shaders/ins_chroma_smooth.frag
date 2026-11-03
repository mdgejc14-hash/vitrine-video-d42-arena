#version 300 es
precision mediump float;
in vec2 vTexSamplingCoord;
out vec4 fragColor;

uniform sampler2D uTexSampler;
uniform float uStrength;        // pilotee par l'ISO de capture (table R&D effet 5)
uniform vec2 uTexelSize;

void main() {
    vec4 tex = texture(uTexSampler, vTexSamplingCoord);
    float luma = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    vec3 sum = vec3(0.0);
    float wsum = 0.0;
    for (int i = -2; i <= 2; ++i) {
        for (int j = -2; j <= 2; ++j) {
            vec3 n = texture(uTexSampler, vTexSamplingCoord + uTexelSize * vec2(float(i), float(j))).rgb;
            float w = 1.0 - abs(dot(n, vec3(0.299, 0.587, 0.114)) - luma);
            sum += n * w;
            wsum += w;
        }
    }
    vec3 avg = sum / wsum;
    // lissage CHROMA seul : la luma originale reste intacte (regle d'or fidelite)
    vec3 chromaAvg = avg - vec3(dot(avg, vec3(0.299, 0.587, 0.114)));
    vec3 chromaOrig = tex.rgb - vec3(luma);
    fragColor = vec4(clamp(vec3(luma) + mix(chromaOrig, chromaAvg, uStrength), 0.0, 1.0), tex.a);
}
