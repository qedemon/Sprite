//
//  core.cpp
//  spriteTest
//
//  Created by KimTaeseok on 2015. 2. 17..
//  Copyright (c) 2015년 KimTaeseok. All rights reserved.
//

#include <iostream>
#include "core.h"
#include "LoadShader.h"
#include "SOIL/SOIL.h"
#include "glm/glm.hpp"
#include "glm/gtc/type_ptr.hpp"
#include "glm/gtc/matrix_transform.hpp"

GLuint program;

typedef struct Point{
    float pos[2];
    float velocity[2];
    float color[3];
    float rad;
}Point;

GLuint buffer[2];
GLuint vao[2];
GLuint pointTex;

GLint nPoint;
GLfloat hor=0;

uint64_t pastTime;
GLint timeLocation;
GLint scaleLocation;
GLint frameLocation;
GLint hLocation;

GLint whiteEnableLocation;
GLint whiteEnable=0;
GLint whiteHoleLocation;
GLfloat whiteHolePos[2];

float width;
float height;

void Init(float w, float h){
    width=w;
    height=h;
    std::cout<<glGetString(GL_VERSION)<<std::endl;
    ShaderInfo info[]{
        {GL_VERTEX_SHADER, "shader/sprite.vert"},
        {GL_FRAGMENT_SHADER, "shader/sprite.frag"},
        {GL_NONE, NULL}
    };
    program=LoadShaders(info);
    const GLchar* varyings[]={
        "rPos",
        "rVelocity",
        "rColor",
        "gl_SkipComponents1"
    };
    glTransformFeedbackVaryings(program, sizeof(varyings)/sizeof(GLchar*), varyings, GL_INTERLEAVED_ATTRIBS);
    glLinkProgram(program);
    glUseProgram(program);
    glEnable(GL_PROGRAM_POINT_SIZE);
    for(int i=0; i<sizeof(varyings)/sizeof(GLchar*); i++){
        char name[20];
        GLsizei size;
        GLenum type;
        glGetTransformFeedbackVarying(program, i, 20, NULL, &size, &type, name);
    }
    
    nPoint=2000;
    Point* p=new Point[nPoint];
    for(int i=0; i<nPoint; i++){
        float angle=glm::pi<float>()*2.0f*(float)i/nPoint;
        p[i].pos[0]=0.8*glm::cos(angle);//((float)i+0.5)/(float)nPoint*2.0f-1.0f;
        p[i].pos[1]=0.8*glm::sin(angle);
        
        p[i].velocity[0]=0;//0.5*glm::cos(angle);
        p[i].velocity[1]=0;//0.5*glm::sin(angle);
        float t=6*(float)i/nPoint;
        if(t<1){
            p[i].color[0]=1;
            p[i].color[1]=t;
            p[i].color[2]=0;
        }
        else if(t<2){
            t=t-1;
            p[i].color[0]=1-t;
            p[i].color[1]=1;
            p[i].color[2]=0;
        }
        else if(t<3){
            t=t-2;
            p[i].color[0]=0;
            p[i].color[1]=1;
            p[i].color[2]=t;
        }
        else if(t<4){
            t=t-3;
            p[i].color[0]=0;
            p[i].color[1]=1-t;
            p[i].color[2]=1;
        }
        else if(t<5){
            t=t-4;
            p[i].color[0]=t;
            p[i].color[1]=0;
            p[i].color[2]=1;
        }
        else if(t<6){
            t=t-5;
            p[i].color[0]=1;
            p[i].color[1]=0;
            p[i].color[2]=1-t;
        }
        p[i].rad=0.5/(float)nPoint;
        if(p[i].rad<0.01)
            p[i].rad=0.01;
    }
    glGenBuffers(2, buffer);
    glGenVertexArrays(2, vao);
    
    for(int i=0; i<2; i++){
        glBindBuffer(GL_ARRAY_BUFFER, buffer[i]);
        glBufferData(GL_ARRAY_BUFFER, nPoint*sizeof(Point), p, GL_DYNAMIC_COPY);
        
        glBindVertexArray(vao[i]);
        glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, sizeof(Point), (GLvoid*)offsetof(Point, pos));
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(Point), (GLvoid*)offsetof(Point, color));
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(Point), (GLvoid*)offsetof(Point, velocity));
        glEnableVertexAttribArray(2);
        glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, sizeof(Point), (GLvoid*)offsetof(Point, rad));
        glEnableVertexAttribArray(3);
    }
    glBindVertexArray(vao[0]);
    
    timeLocation=glGetUniformLocation(program, "timeDelta");
    scaleLocation=glGetUniformLocation(program, "scale");
    glUniform1f(scaleLocation, w*100);
    GLint nPointLocation=glGetUniformLocation(program, "nPoint");
    glUniform1i(nPointLocation, nPoint);
    frameLocation=glGetUniformLocation(program, "frame");
    
    glGenBuffers(1, &pointTex);
    glBindBuffer(GL_TEXTURE_BUFFER, pointTex);
    
    hLocation=glGetUniformLocation(program, "hor");
    
    whiteEnableLocation=glGetUniformLocation(program, "validWhiteHole");
    whiteHoleLocation=glGetUniformLocation(program, "whiteHole");
    
    
    glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE, GL_ONE, GL_ONE);
    glEnable(GL_BLEND);
}
void Reshape(float w, float h){
    glViewport(0, 0, w, h);
    width=w;
    height=h;
    //glUniform1f(scaleLocation, w);
}
void Draw(uint64_t time){
    static int frame=0;
    if(frame==0){
        pastTime=time;
    }
    float timeDelta=(time-pastTime)/1000.0f;
    glUniform1f(timeLocation, timeDelta);
    glUniform1i(frameLocation, frame);
    glUniform1f(hLocation, hor);
    glUniform1i(whiteEnableLocation, whiteEnable);
    glUniform2f(whiteHoleLocation, whiteHolePos[0], whiteHolePos[1]);
    glClear(GL_COLOR_BUFFER_BIT);
    
    if(frame%2==0){
        glBindVertexArray(vao[0]);
        glBindBufferBase(GL_TRANSFORM_FEEDBACK_BUFFER, 0, buffer[1]);
        glTexBuffer(GL_TEXTURE_BUFFER, GL_RGBA32F, buffer[0]);
    }
    else{
        glBindVertexArray(vao[1]);
        glBindBufferBase(GL_TRANSFORM_FEEDBACK_BUFFER, 0, buffer[0]);
        glTexBuffer(GL_TEXTURE_BUFFER, GL_RGBA32F, buffer[1]);
    }
    glBeginTransformFeedback(GL_POINTS);
    glDrawArrays(GL_POINTS, 0, nPoint);
    glEndTransformFeedback();
    pastTime=time;
    frame++;
}
void MouseDown(int button, float x, float y){
    if(button==0){
        whiteEnable=1;
        whiteHolePos[0]=(x-width/2)/width;
        whiteHolePos[1]=(y-height/2)/height;
    }
}

void MouseUp(int button, float x, float y){
    if(button==0){
        whiteEnable=0;
    }
}
void MouseMove(int pressed, float x, float y){
    if(pressed==1){
        whiteHolePos[0]=(x-width/2)/width;
        whiteHolePos[1]=(y-height/2)/height;
    }
}

void KeyDown(int key){
    if(key==123){
        hor-=0.1;
        if(hor<-1.0f)
            hor=-1;
    }
    else if(key==124){
        hor+=0.1;
        if(hor>1.0f){
            hor=1;
        }
    }
}
