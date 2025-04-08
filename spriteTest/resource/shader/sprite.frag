#version 410 core

in vec3 vColor;
out vec4 fColor;
void main(){
    vec2 temp = gl_PointCoord - vec2(0.5);
    float f = clamp(1.0f-sqrt(dot(temp, temp))*2.0, 0, 1);
    float alpha=f*f*f*f;
    fColor =vec4(vColor, alpha);// mix(color1, color2, smoothstep(0.1, 0.25, f));
}
