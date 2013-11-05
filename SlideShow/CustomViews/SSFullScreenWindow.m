//
//  SSFullScreenWindow.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 04.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSFullScreenWindow.h"

@implementation SSFullScreenWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation {
    NSRect mainScreenFrame = [[NSScreen mainScreen] frame];
    self = [super initWithContentRect:mainScreenFrame styleMask:windowStyle backing:bufferingType defer:deferCreation];
    if ( self ) {
        self.level = NSMainMenuWindowLevel + 1;
        self.excludedFromWindowsMenu = YES;
        self.hidesOnDeactivate = YES;
    }
    return self;
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (BOOL)canBecomeMainWindow {
    return YES;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)cancelOperation:(id)sender {
    [self close];
}

- (void)setScreen:(NSScreen*)screen {
    NSRect screenRect = screen.frame;
    [self setFrameOrigin:screenRect.origin];
    [self setContentSize:screenRect.size];
}

@end
