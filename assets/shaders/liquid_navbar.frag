#version 320 es
precision mediump float;

#include <flutter/runtime_effect.glsl>

// Uniform parameters
layout(location = 0) uniform float uWidth;           // Navbar genişliği
layout(location = 1) uniform float uHeight;          // Navbar yüksekliği
layout(location = 2) uniform float uActiveTab;       // Aktif tab index (0-4)
layout(location = 3) uniform float uAnimationProgress; // Animasyon progress (0-1)
layout(location = 4) uniform float uTabCount;        // Toplam tab sayısı
layout(location = 5) uniform float uTime;            // Zaman (animasyon için)

// Glass properties
layout(location = 6) uniform float uGlassColorR;
layout(location = 7) uniform float uGlassColorG;
layout(location = 8) uniform float uGlassColorB;
layout(location = 9) uniform float uGlassColorA;
layout(location = 10) uniform float uThickness;      // Cam kalınlığı
layout(location = 11) uniform float uLightIntensity; // Işık yoğunluğu

vec4 uGlassColor = vec4(uGlassColorR, uGlassColorG, uGlassColorB, uGlassColorA);

uniform sampler2D uBackgroundTexture;
layout(location = 0) out vec4 fragColor;

// SDF (Signed Distance Field) fonksiyonları
float sdfRoundedRect(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - b + r;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

float sdfCircle(vec2 p, float r) {
    return length(p) - r;
}

float sdfEllipse(vec2 p, vec2 r) {
    r = max(r, 1e-4);
    float k1 = length(p / r);
    float k2 = length(p / (r * r));
    return (k1 * (k1 - 1.0)) / max(k2, 1e-4);
}

// Smooth union (shapes blend together)
float smoothUnion(float d1, float d2, float k) {
    float e = max(k - abs(d1 - d2), 0.0);
    return min(d1, d2) - e * e * 0.25 / k;
}

// Ana navbar şeklini hesapla
float navbarSDF(vec2 p) {
    // Navbar temel şekli - rounded rectangle
    vec2 navbarCenter = vec2(uWidth / 2.0, uHeight / 2.0);
    vec2 navbarSize = vec2(uWidth / 2.0 - 20.0, uHeight / 2.0 - 10.0);
    float navbar = sdfRoundedRect(p - navbarCenter, navbarSize, 25.0);
    
    // Aktif tab için liquid bubble efekti
    if (uAnimationProgress > 0.0) {
        float tabWidth = uWidth / uTabCount;
        vec2 activeTabCenter = vec2(
            (uActiveTab + 0.5) * tabWidth,
            uHeight * 0.3
        );
        
        // Liquid bubble - animated radius
        float maxRadius = 35.0;
        float currentRadius = maxRadius * uAnimationProgress;
        
        // Animated position offset
        float timeOffset = sin(uTime * 3.0) * 2.0 * uAnimationProgress;
        activeTabCenter.y += timeOffset;
        
        float bubble = sdfEllipse(p - activeTabCenter, vec2(currentRadius, currentRadius * 0.8));
        
        // Smooth union ile navbar ve bubble'ı birleştir
        navbar = smoothUnion(navbar, bubble, 20.0 * uAnimationProgress);
    }
    
    return navbar;
}

// Normal vector hesaplama (lighting için)
vec3 calculateNormal(vec2 p, float thickness) {
    const float eps = 2.0;
    float sd = navbarSDF(p);
    
    float dx = navbarSDF(p + vec2(eps, 0.0)) - navbarSDF(p - vec2(eps, 0.0));
    float dy = navbarSDF(p + vec2(0.0, eps)) - navbarSDF(p - vec2(0.0, eps));
    
    float n_cos = max(thickness + sd, 0.0) / thickness;
    float n_sin = sqrt(max(0.0, 1.0 - n_cos * n_cos));
    
    return normalize(vec3(dx * n_cos, dy * n_cos, n_sin));
}

// Lighting hesaplama
vec3 calculateLighting(vec2 uv, vec3 normal) {
    vec3 lightDir = normalize(vec3(0.3, -0.5, 0.8));
    vec3 viewDir = vec3(0.0, 0.0, 1.0);
    
    // Fresnel effect (rim lighting)
    float fresnel = pow(1.0 - max(0.0, dot(normal, viewDir)), 2.0);
    vec3 rimLight = vec3(fresnel * 0.3);
    
    // Specular highlight
    vec3 halfwayDir = normalize(lightDir + viewDir);
    float specular = pow(max(0.0, dot(normal, halfwayDir)), 64.0);
    vec3 specularLight = vec3(specular * uLightIntensity * 0.5);
    
    // Ambient light
    vec3 ambientLight = vec3(0.1);
    
    return rimLight + specularLight + ambientLight;
}

void main() {
    vec2 screenUV = FlutterFragCoord().xy / vec2(uWidth, uHeight);
    vec2 p = FlutterFragCoord().xy;
    
    // SDF değerini hesapla
    float sd = navbarSDF(p);
    
    // Alpha değeri (smooth edge için)
    float alpha = 1.0 - smoothstep(-2.0, 2.0, sd);
    
    // Eğer tamamen dışarıdaysak, background'u göster
    if (alpha < 0.01) {
        fragColor = texture(uBackgroundTexture, screenUV);
        return;
    }
    
    // Background color
    vec4 backgroundColor = texture(uBackgroundTexture, screenUV);
    
    // Glass effect için refraction
    vec3 normal = calculateNormal(p, uThickness);
    vec2 refractionOffset = normal.xy * uThickness * 0.01;
    vec2 refractedUV = screenUV + refractionOffset;
    
    // Refracted background
    vec4 refractedColor = texture(uBackgroundTexture, refractedUV);
    
    // Glass color mixing
    vec4 glassEffect = mix(refractedColor, uGlassColor, uGlassColor.a * 0.5);
    
    // Lighting effects
    vec3 lighting = calculateLighting(screenUV, normal);
    glassEffect.rgb += lighting * alpha;
    
    // Active tab glow effect
    if (uAnimationProgress > 0.0) {
        float tabWidth = uWidth / uTabCount;
        vec2 activeTabCenter = vec2((uActiveTab + 0.5) * tabWidth, uHeight * 0.3);
        float distToActiveTab = length(p - activeTabCenter);
        float glowRadius = 50.0 * uAnimationProgress;
        float glow = exp(-distToActiveTab / glowRadius) * uAnimationProgress * 0.3;
        
        // Active tab color (mavi-mor gradient)
        vec3 activeColor = mix(vec3(0.2, 0.5, 1.0), vec3(0.5, 0.2, 1.0), sin(uTime * 2.0) * 0.5 + 0.5);
        glassEffect.rgb += activeColor * glow;
    }
    
    // Final color blending
    fragColor = mix(backgroundColor, glassEffect, alpha);
    
    // Ensure alpha is correct
    fragColor.a = mix(backgroundColor.a, glassEffect.a, alpha);
} 