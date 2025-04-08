//
//  core.h
//  spriteTest
//
//  Created by KimTaeseok on 2015. 2. 17..
//  Copyright (c) 2015년 KimTaeseok. All rights reserved.
//

#ifndef spriteTest_core_h
#define spriteTest_core_h

#include <stdint.h>

void Init(float w, float h);
void Reshape(float w, float h);
void Draw(uint64_t time);
void MouseDown(int button, float x, float y);
void MouseUp(int button, float x, float y);
void MouseMove(int pressed, float x, float y);
void KeyDown(int key);

#endif
