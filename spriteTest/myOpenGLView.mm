//
//  myOpenGLView.m
//  spriteTest
//
//  Created by KimTaeseok on 2015. 2. 17..
//  Copyright (c) 2015년 KimTaeseok. All rights reserved.
//

#import "myOpenGLView.h"
#include "core.h"

@implementation myOpenGLView

static CVReturn MyDisplayLinkCallback(CVDisplayLinkRef displayLink, const CVTimeStamp* now, const CVTimeStamp* outputTime, CVOptionFlags flagsIn, CVOptionFlags* flagsOut, void* displayLinkContext)
{
    CVReturn result = [(__bridge myOpenGLView*)displayLinkContext getFrameForTime: now];
    return result;
}

+ (NSOpenGLPixelFormat*) defaultPixelFormat{
    NSOpenGLPixelFormatAttribute attribute[]={
        NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core,
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFADepthSize, 32,
        NSOpenGLPFAStencilSize, 8,
        0
    };
    return [[NSOpenGLPixelFormat alloc] initWithAttributes:attribute];
}

- (id) initWithFrame:(NSRect)frameRect{
    self=[super initWithFrame:(NSRect) frameRect];
    if(self){
        NSOpenGLPixelFormat* pf=[[self class] defaultPixelFormat];
        NSOpenGLContext* context=[[NSOpenGLContext alloc] initWithFormat:pf shareContext:nil];
        [self setPixelFormat:pf];
        [self setOpenGLContext:context];
        [self prepareOpenGLAndStartDisplayLink];
    }
    return self;
}

- (void) awakeFromNib{
    NSOpenGLPixelFormat* pf=[[self class] defaultPixelFormat];
    NSOpenGLContext* context=[[NSOpenGLContext alloc] initWithFormat:pf shareContext:nil];
    [self setPixelFormat:pf];
    [self setOpenGLContext:context];
    [self prepareOpenGLAndStartDisplayLink];
    [[self superview]setAutoresizingMask:NSViewWidthSizable];
}

- (void) prepareOpenGLAndStartDisplayLink{
    GLint swapInterval=1;
    [[self openGLContext] setValues:&swapInterval forParameter:NSOpenGLCPSwapInterval];
    CGLContextObj cglContext=[[self openGLContext] CGLContextObj];
    CGLPixelFormatObj cglPixelFormat=[[self pixelFormat] CGLPixelFormatObj];
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
    CVDisplayLinkSetOutputCallback(displayLink, MyDisplayLinkCallback, (__bridge void*) self);
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cglContext, cglPixelFormat);
    CVDisplayLinkStart(displayLink);
    isRunning=YES;
    
    CFBundleRef mainBundle=CFBundleGetMainBundle();
    CFURLRef resourceURL=CFBundleCopyResourcesDirectoryURL(mainBundle);
    unsigned char resourcePath[PATH_MAX];
    if(!CFURLGetFileSystemRepresentation(resourceURL, 1, (unsigned char*)resourcePath, PATH_MAX)){
        NSLog(@"Could not generate resource file path\n");
        return;
    }
    chdir((char*) resourcePath);
    std::cout<<resourcePath<<std::endl;
    [[self openGLContext] makeCurrentContext];
    Init(self.bounds.size.width, self.bounds.size.height);
}

#include <iostream>

- (void) reshape{
    float w=self.bounds.size.width;
    float h=self.bounds.size.height;
    CGLLockContext([[self openGLContext] CGLContextObj]);
    Reshape(w, h);
    [[self openGLContext] update];
    
    CGLUnlockContext([[self openGLContext] CGLContextObj]);
}

- (CVReturn) getFrameForTime:(const CVTimeStamp*)outputTime{
    CGLContextObj cglContext=[[self openGLContext] CGLContextObj];
    CGLLockContext(cglContext);
    CGLSetCurrentContext(cglContext);
    Draw(outputTime->videoTime*1000/outputTime->videoTimeScale);
    CGLFlushDrawable(cglContext);
    CGLUnlockContext(cglContext);
    return kCVReturnSuccess;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}

- (void) mouseDown:(NSEvent *)theEvent{
    MouseDown(0, theEvent.locationInWindow.x, theEvent.locationInWindow.y);
}

- (void) mouseUp:(NSEvent *)theEvent{
    MouseUp(0, theEvent.locationInWindow.x, theEvent.locationInWindow.y);
}

- (void) mouseMoved:(NSEvent *)theEvent{
    MouseMove(0, theEvent.locationInWindow.x, theEvent.locationInWindow.y);
}

- (void) mouseDragged:(NSEvent *)theEvent{
    MouseMove(1, theEvent.locationInWindow.x, theEvent.locationInWindow.y);
}

- (void) keyDown:(NSEvent *)theEvent{
    if([theEvent keyCode]==53){
        NSLog(@"Exit");
        [self.window close];
        return;
    }
    KeyDown(theEvent.keyCode);
}

- (BOOL) acceptsFirstResponder{
    return YES;
}

- (void) lockFocus{
    [super lockFocus];
    if([[self openGLContext] view]!=self){
        [[self openGLContext] setView: self];
    }
}

@end
