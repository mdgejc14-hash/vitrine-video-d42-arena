#version 300 es
precision mediump float;          // T5 : mediump double le debit sur Mali/Adreno

in vec2 vTexSamplingCoord;
out vec4 fragColor;

uniform sampler2D uTexSampler;    // entree : RGB ELECTRIQUE SMPTE 170M explicite
                                  // (erratum v1 6.6 : jamais de lineaire 8 bits = banding)
uniform sampler2D uLutSampler;    // LUT 33x33x33 en bande 2D : 33 tuiles de 33x33 (1089x33)
uniform sampler2D uSkinMask;      // masque peau 64x64 (ML Kit, lisse temporellement)
uniform float uExposureGain;      // bloc 2 : gain du plan (Theoreme 1 : homothetie RGB)
uniform vec3 uWbAnchor;           // bloc 3 : ancrage balance des blancs, borne +/-0,15
uniform vec3 uProductHue;         // bloc 4 : reference teinte produit (RGB normalise)
uniform float uProductTolerance;  // bloc 4 : tolerance |h - h_prod| (defaut 20 degres)
uniform float uChromaSmooth;      // bloc 6 : force lissage chroma seul (Regle C1)
uniform vec2 uTexelSize;

const float LUT_SIZE = 33.0;
const float LUT_TILES = 33.0;

/* ---------- bloc 1 : LUT 3D statique (cuite hors ligne, protection chair incluse) ---------- */
vec3 applyLut33(vec3 c) {
    vec3 clamped = clamp(c, 0.0, 1.0);
    float blue = clamped.b * (LUT_SIZE - 1.0);
    float b0 = floor(blue);
    float b1 = min(b0 + 1.0, LUT_SIZE - 1.0);
    float fb = fract(blue);
    vec2 scale = vec2(LUT_SIZE / (LUT_SIZE * LUT_TILES), 1.0 / LUT_SIZE);
    vec2 inTile = (clamped.rg * (LUT_SIZE - 1.0) + 0.5) * scale;
    vec3 s0 = texture(uLutSampler, vec2((b0 + 0.5) / LUT_TILES, 0.0) + inTile).rgb;
    vec3 s1 = texture(uLutSampler, vec2((b1 + 0.5) / LUT_TILES, 0.0) + inTile).rgb;
    return mix(s0, s1, fb);
}

/* ---------- Theoreme 2 : gamut clip preservant la teinte (c * M / max(c)) ---------- */
vec3 gamutClipHuePreserving(vec3 c) {
    float m = max(c.r, max(c.g, c.b));
    return (m > 1.0) ? c / m : c;
}

/* ---------- luma SMPTE 170M (electrique) ---------- */
float luma170M(vec3 c) {
    return dot(c, vec3(0.299, 0.587, 0.114));
}

void main() {
    vec4 tex = texture(uTexSampler, vTexSamplingCoord);
    vec3 c = tex.rgb;

    /* 1 - LUT statique : courbe de tonalite + look gabarit + protection chair */
    c = applyLut33(c);

    /* 2 - gain d'exposition : HOMOTHETIE RGB => teinte invariante (Theoreme 1 v2) */
    c = c * uExposureGain;

    /* 3 - ancrage balance des blancs : W constant par plan, borne +/-0,15 */
    c = c * clamp(uWbAnchor, vec3(0.85), vec3(1.15));

    /* 4 - verrou produit : si teinte proche de la reference et chroma > seuil,
          on ramene la teinte sur la reference (homothetie composante par composante) */
    float l = luma170M(c);
    vec3 chroma = c - vec3(l);
    float chromaLen = length(chroma);
    float refLen = length(uProductHue - vec3(luma170M(uProductHue)));
    float hueDot = (chromaLen > 1e-4 && refLen > 1e-4)
        ? dot(normalize(chroma), normalize(uProductHue - vec3(luma170M(uProductHue))))
        : 0.0;
    float nearProduct = smoothstep(cos(radians(uProductTolerance)), 1.0, hueDot)
        * step(0.047, chromaLen);              // C* > 12 (echelle 0-255 => 0.047)
    c = mix(c, vec3(l) + chroma * (refLen / max(chromaLen, 1e-4)) * hueDot, nearProduct * 0.5);

    /* 5 - gamut clip preservant la teinte (Theoreme 2) */
    c = gamutClipHuePreserving(c);

    /* 6 - masque peau 64x64 : lissage CHROMA seul (C1), luma intacte => fidele */
    float mask = texture(uSkinMask, vTexSamplingCoord).r * uChromaSmooth;
    vec3 n1 = texture(uTexSampler, vTexSamplingCoord + vec2(uTexelSize.x, 0.0)).rgb;
    vec3 n2 = texture(uTexSampler, vTexSamplingCoord - vec2(uTexelSize.x, 0.0)).rgb;
    vec3 n3 = texture(uTexSampler, vTexSamplingCoord + vec2(0.0, uTexelSize.y)).rgb;
    vec3 n4 = texture(uTexSampler, vTexSamplingCoord - vec2(0.0, uTexelSize.y)).rgb;
    vec3 localAvg = 0.25 * (n1 + n2 + n3 + n4);
    float lumaOut = luma170M(c);
    vec3 chromaAvg = localAvg - vec3(luma170M(localAvg));
    vec3 smoothedChroma = mix(c - vec3(lumaOut), chromaAvg, mask);
    c = vec3(lumaOut) + smoothedChroma;          // accentuation/lissage ne touchent pas la luma

    fragColor = vec4(clamp(c, 0.0, 1.0), tex.a);
}
