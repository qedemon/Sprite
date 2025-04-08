#version 410 core

layout(location=0) in vec2 pos;
layout(location=1) in vec3 color;
layout(location=2) in vec2 velocity;
layout(location=3) in float rad;

uniform float scale=0;
uniform vec4 boundary=vec4(-2.0f, 2.0f, -1.0f, 1.0f);//*0.9;
uniform int frame;
uniform float timeDelta=0;
uniform samplerBuffer pointBuffer;
uniform int nPoint;

out vec2 rPos;
out vec3 rColor;
out vec2 rVelocity;
out float rRad;

out vec3 vColor;

uniform float damp=0.1;
uniform float g=-3.0;
uniform float hor=0;

uniform vec2 whiteHole=vec2(0, 0);
uniform int validWhiteHole=0;


float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec3 getRGB(float hue){
    int n=int(floor(hue*6));
    float f=fract(hue*6);
    switch(n){
        case 0:
            return vec3(1.0, f, 0);
        case 1:
            return vec3(1-f, 1.0, 0);
        case 2:
            return vec3(0, 1.0, f);
        case 3:
            return vec3(0, 1-f, 1);
        case 4:
            return vec3(f, 0, 1);
        case 5:
        default:
            return vec3(1, 0, 1-f);
    }
}

void reGenPoint(){
    rPos.y=1;
    float t=rand(vec2(float(frame), float(frame)));
    rPos.x=0.15*(t-0.5)+hor;
    rVelocity.x=(t-0.5);
    rVelocity.y=-1;
    rColor=getRGB(fract(float(frame)/200.0f));
}

void main(){
    rColor=color;
    rRad=rad;
    rPos=pos;
    rVelocity=velocity;
    
    bool col=false;
    for(int i=0; i<nPoint; i++){
        if(gl_VertexID!=i){
            vec4 posV=texelFetch(pointBuffer, 2*i);
            vec2 cPos=posV.xy;
            vec2 cVelo=posV.zw;
            float cRad=texelFetch(pointBuffer, 2*i+1).w;
            
            vec2 relativePos=rPos-cPos;
            float rr=dot(relativePos, relativePos);
            if(rr<(cRad+rad)*(cRad+rad)){
                vec2 relativeVelo=rVelocity-cVelo;
                float dir=dot(relativePos, relativeVelo);
                if(dir<0){
                    rVelocity=rVelocity-dir/rr*relativePos;
                }
                rPos=-0.5*rPos+1.5*cPos+3*rad*normalize(relativePos);
            }
        }
    }
    
    if(pos.x-rad<=boundary.x){
        if(rVelocity.x-rad<0){
            reGenPoint();
            //rPos.x=2*boundary.x-rPos.x+2*rad;
            //rVelocity.x=-rVelocity.x;
        }
    }
    else if(pos.x+rad>=boundary.y){
        if(rVelocity.x>0){
            reGenPoint();
            //rPos.x=2*boundary.y-rPos.x-2*rad;
            //rVelocity.x=-rVelocity.x;
        }
    }
    if(pos.y-rad<=boundary.z){
        if(rVelocity.y<0){
            rPos.y=2*boundary.z-rPos.y+2*rad;
            rVelocity.y=-0.5*rVelocity.y;
        }
    }
    else if(pos.y+rad>=boundary.w){
        if(rVelocity.y>0){
            rPos.y=2*boundary.w-rPos.y-2*rad;
            rVelocity.y=-0.5*rVelocity.y;
        }
    }
    vec2 vr=rPos-whiteHole;
    float r2=dot(vr, vr);
    vec2 accel=vec2(0, g)-damp*rVelocity;
    if(validWhiteHole>0){
        accel+=1/r2*normalize(vr);
    }
    rPos=rPos+velocity*timeDelta+0.5*accel*timeDelta*timeDelta;
    rVelocity=rVelocity+accel*timeDelta;
    gl_Position=vec4(rPos, 0, 1);
    gl_PointSize=rad*scale;
    
    vColor=color;
}
