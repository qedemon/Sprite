//
//  myOpenGLView.h
//  spriteTest
//
//  Created by KimTaeseok on 2015. 2. 17..
//  Copyright (c) 2015년 KimTaeseok. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface myOpenGLView : NSOpenGLView{
    Boolean isRunning;
    CVDisplayLinkRef displayLink;
}
@end
