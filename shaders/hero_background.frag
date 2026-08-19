#version 460 core

// Slow-drifting pastel "mesh gradient" for the hero band.
// Palette stays within the site's sky/yellow/teal tints so text keeps contrast.

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

const vec3 kBase   = vec3(0.906, 0.973, 1.000); // #E7F8FF sky
const vec3 kDeep   = vec3(0.604, 0.843, 0.988); // #9AD7FC deeper sky
const vec3 kButter = vec3(1.000, 0.945, 0.612); // #FFF19C soft yellow
const vec3 kMint   = vec3(0.639, 0.933, 0.875); // #A3EEDF soft teal
const vec3 kPink   = vec3(0.973, 0.812, 0.878); // #F8CFE0 soft pink
const vec3 kWhite  = vec3(0.980, 0.997, 1.000); // airy white

float blob(vec2 p, vec2 center, float radius) {
  return smoothstep(radius, 0.0, distance(p, center));
}

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
  float aspect = uSize.x / uSize.y;
  vec2 p = vec2(uv.x * aspect, uv.y);

  float t = uTime * 0.3;

  vec3 col = kBase;

  // deeper sky drifting around the collage side
  vec2 c1 = vec2(aspect * (0.74 + 0.07 * sin(t * 0.70)), 0.28 + 0.16 * cos(t * 0.55));
  col = mix(col, kDeep, 0.85 * blob(p, c1, 1.05));

  // airy white keeping the text side light
  vec2 c2 = vec2(aspect * (0.16 + 0.04 * sin(t * 0.45 + 1.7)), 0.28 + 0.08 * cos(t * 0.60 + 0.6));
  col = mix(col, kWhite, 0.65 * blob(p, c2, 0.75));

  // soft yellow glow, echoes the collage circle
  vec2 c3 = vec2(aspect * (0.56 + 0.09 * cos(t * 0.50 + 2.4)), 0.60 + 0.14 * sin(t * 0.65 + 1.2));
  col = mix(col, kButter, 0.60 * blob(p, c3, 0.62));

  // mint accent low left, echoes the teal dot
  vec2 c4 = vec2(aspect * (0.28 + 0.10 * sin(t * 0.60 + 4.1)), 0.86 + 0.08 * cos(t * 0.75 + 3.0));
  col = mix(col, kMint, 0.75 * blob(p, c4, 0.68));

  // soft pink drifting along the bottom right
  vec2 c5 = vec2(aspect * (0.92 + 0.06 * cos(t * 0.55 + 5.2)), 0.95 + 0.10 * sin(t * 0.50 + 2.1));
  col = mix(col, kPink, 0.45 * blob(p, c5, 0.55));

  // tiny dither to avoid gradient banding
  float grain = fract(sin(dot(uv * uSize, vec2(12.9898, 78.233))) * 43758.5453);
  col += (grain - 0.5) * (1.5 / 255.0);

  fragColor = vec4(col, 1.0);
}
