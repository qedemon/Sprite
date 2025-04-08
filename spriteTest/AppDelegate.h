//
//  AppDelegate.h
//  spriteTest
//
//  Created by KimTaeseok on 2015. 2. 17..
//  Copyright (c) 2015년 KimTaeseok. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "myOpenGLView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    NSWindow* fullScreenWindow;
    myOpenGLView* fullScreenView;
}
- (IBAction)testMenuItem:(id)sender;

@property (weak) IBOutlet myOpenGLView *theGLView;

@end

