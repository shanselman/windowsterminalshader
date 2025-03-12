#define WINDOWS_TERMINAL

Texture2D shaderTexture;
SamplerState samplerState;

// --------------------
#if defined(WINDOWS_TERMINAL)
cbuffer PixelShaderSettings {
  float  Time;
  float  Scale;
  float2 Resolution;
  float4 Background;
};

#define TIME        Time
#define RESOLUTION  Resolution
#else
float time;
float2 resolution;

#define TIME        time
#define RESOLUTION  resolution
#endif
// --------------------

// --------------------
// GLSL => HLSL adapters
#define vec2  float2
#define vec3  float3
#define vec4  float4
#define mat2  float2x2
#define mat3  float3x3
#define fract frac
#define mix   lerp

float mod(float x, float y) {
  return x - y * floor(x/y);
}

vec2 mod(vec2 x, vec2 y) {
  return x - y * floor(x/y);
}

static const vec2 unit2 = vec2(1.0, 1.0);
static const vec3 unit3 = vec3(1.0, 1.0, 1.0);
static const vec4 unit4 = vec4(1.0, 1.0, 1.0, 1.0);
// --------------------

// Simple Mandelbrot set fractal shader

// HSV to RGB conversion
static const vec4 hsv2rgb_K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
vec3 hsv2rgb(vec3 c) {
  vec3 p = abs(fract(c.xxx + hsv2rgb_K.xyz) * 6.0 - hsv2rgb_K.www);
  return c.z * mix(hsv2rgb_K.xxx, clamp(p - hsv2rgb_K.xxx, 0.0, 1.0), c.y);
}

// Mandelbrot set calculation
vec3 mandelbrot(vec2 uv) {
  // Zoom changes over time
  float zoom = 2.5 * (1.0 + 0.5 * sin(TIME * 0.1));
  
  // Center point with some motion
  vec2 center = vec2(-0.5 + 0.1 * sin(TIME * 0.17), 0.0 + 0.1 * cos(TIME * 0.13));
  
  // Scale and translate coordinates
  vec2 c = center + uv / zoom;
  
  // Mandelbrot iteration
  vec2 z = vec2(0.0, 0.0);
  int maxIter = 100;
  int iter = 0;
  
  for (int i = 0; i < maxIter; i++) {
    // z = z^2 + c
    z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;
    
    if (dot(z, z) > 4.0) break;
    iter++;
  }
  
  // Smooth coloring
  float smoothVal = float(iter) - log2(log2(dot(z, z))) + 4.0;
  smoothVal = smoothVal / float(maxIter);
  
  // Color based on iteration count
  float hue = fract(0.95 + 0.2 * smoothVal + TIME * 0.05);
  float sat = 0.8;
  float val = iter < maxIter ? 1.0 : 0.0; // Black for points in the set
  
  // Add some color variation 
  return hsv2rgb(vec3(hue, sat, val));
}

// License: Unknown, author: nmz (twitter: @stormoid), found: https://www.shadertoy.com/view/NdfyRM
float sRGB(float t) { return mix(1.055*pow(t, 1./2.4) - 0.055, 12.92*t, step(t, 0.0031308)); }
vec3 sRGB(in vec3 c) { return vec3 (sRGB(c.x), sRGB(c.y), sRGB(c.z)); }

// Color adjustment
vec3 adjustColor(vec3 color) {
  // Apply some gamma correction and color enhancement
  color = pow(color, vec3(0.8, 0.8, 0.8)); 
  return clamp(color, 0.0, 1.0);
}

#if defined(WINDOWS_TERMINAL)
float4 main(float4 pos : SV_POSITION, float2 tex : TEXCOORD) : SV_TARGET
#else
float4 ps_main(float4 pos : SV_POSITION, float2 tex : TEXCOORD) : SV_TARGET
#endif
{
  // Normalize coordinates
  vec2 q = tex;
  vec2 p = -1.0 + 2.0 * q;
  
  #if defined(WINDOWS_TERMINAL)
  p.y = -p.y;
  #endif
  
  // Adjust aspect ratio
  p.x *= RESOLUTION.x / RESOLUTION.y;
  
  // Get fractal color
  vec3 col = mandelbrot(p);
  
  // Apply color adjustments
  col = adjustColor(col);
  col = sRGB(col);
  
  // Composite with terminal content
  vec4 fg = shaderTexture.Sample(samplerState, q);
  vec4 sh = shaderTexture.Sample(samplerState, q - 2.0 * unit2 / RESOLUTION.xy);
  
  // Mix background with terminal content
  col = mix(col, 0.0 * unit3, sh.w);
  col = mix(col, fg.xyz, fg.w);
  
  return vec4(col, 1.0);
}