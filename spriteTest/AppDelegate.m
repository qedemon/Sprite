//
//  AppDelegate.m
//  spriteTest
//
//  Created by KimTaeseok on 2015. 2. 17..
//  Copyright (c) 2015년 KimTaeseok. All rights reserved.
//

#import "AppDelegate.h"
#import "MyWindow.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"Launch");
    NSRect mainDisplayRect, viewRect;
    mainDisplayRect=[[NSScreen mainScreen] frame];
    fullScreenWindow=[[MyWindow alloc] initWithContentRect:mainDisplayRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES];
    
    [fullScreenWindow setLevel:NSMainMenuWindowLevel+1];
    [fullScreenWindow setOpaque:YES];
    [fullScreenWindow setHidesOnDeactivate:YES];
    
    viewRect=NSMakeRect(0.0, 0.0, mainDisplayRect.size.width, mainDisplayRect.size.height);
    fullScreenView=[[myOpenGLView alloc]initWithFrame:viewRect];
    [fullScreenWindow setContentView:fullScreenView];
    
    [fullScreenWindow makeKeyAndOrderFront:self];
    [fullScreenWindow makeMainWindow];
    [fullScreenWindow makeFirstResponder:fullScreenView];}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (NSSize) windowWillResize:(NSWindow*)sender toSize:(NSSize)frameSize{
    NSRect rect;
    rect.origin.x=0;
    rect.origin.y=0;
    float temp=frameSize.width<frameSize.height?frameSize.width:frameSize.height;
    rect.size.width=temp;
    rect.size.height=temp;
    _theGLView.frame=rect;
    _theGLView.bounds=rect;
    return rect.size;
}

- (IBAction)testMenuItem:(id)sender {
    NSLog(@"menu item testing...");
}
@end
