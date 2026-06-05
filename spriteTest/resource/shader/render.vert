#version 410 core

// Per-vertex (the quad corners, [-1,1])
layout(location=0) in vec2 corner;
// Per-instance (one particle), read from the simulated particle buffer
layout(location=1) in vec2 pos;
layout(location=2) in vec3 color;
layout(location=3) in float rad;

uniform float sizeScale; // NDC size per unit radius
uniform float aspect;    // height/width, keeps sprites circular

out vec2 vUV;
out vec3 vColor;

void main(){
    vUV = corner;
    vColor = color;
    vec2 offset = corner * rad * sizeScale;
    offset.x *= aspect;
    gl_Position = vec4(pos + offset, 0.0, 1.0);
}
