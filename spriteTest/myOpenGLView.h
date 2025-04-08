//
//  myOpenGLView.h
//  spriteTest
//
//  Created by KimTaeseok on 2015. 2. 17..
//  Copyright (c) 2015년 KimTaeseok. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface myOpenGLView : NSView{
    Boolean isRunning;
    CVDisplayLinkRef displayLink;
}
@property NSOpenGLPixelFormat* pixelFormat;
@property NSOpenGLContext* openGLContext;
@end
