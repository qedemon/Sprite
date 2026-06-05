#version 410 core

in vec2 vUV;
in vec3 vColor;
out vec4 fColor;

void main(){
    // Soft circular falloff inside the quad (same feel as the old point sprite)
    float d = length(vUV);
    float f = clamp(1.0 - d, 0.0, 1.0);
    float alpha = f*f*f*f;
    fColor = vec4(vColor, alpha);
}
