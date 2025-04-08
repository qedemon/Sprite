//
//  LoadShader.h
//  spriteTest
//
//  Created by KimTaeseok on 2015. 2. 17..
//  Copyright (c) 2015년 KimTaeseok. All rights reserved.
//

#ifndef __spriteTest__LoadShader__
#define __spriteTest__LoadShader__

#include <stdio.h>
#include <iostream>

#include <OpenGL/gl3.h>

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus
    
    //----------------------------------------------------------------------------
    //
    //  LoadShaders() takes an array of ShaderFile structures, each of which
    //    contains the type of the shader, and a pointer a C-style character
    //    string (i.e., a NULL-terminated array of characters) containing the
    //    entire shader source.
    //
    //  The array of structures is terminated by a final Shader with the
    //    "type" field set to GL_NONE.
    //
    //  LoadShaders() returns the shader program value (as returned by
    //    glCreateProgram()) on success, or zero on failure.
    //
    
    typedef struct {
        GLenum       type;
        const char*  filename;
        GLuint       shader;
    } ShaderInfo;
    
    GLuint LoadShaders( ShaderInfo* );
    
    //----------------------------------------------------------------------------
    
#ifdef __cplusplus
};
#endif // __cplusplus

#endif /* defined(__spriteTest__LoadShader__) */
