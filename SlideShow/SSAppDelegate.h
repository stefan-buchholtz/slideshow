//
//  SSAppDelegate.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SSWindowManager;

@interface SSAppDelegate : NSObject <NSApplicationDelegate>

@property (strong) SSWindowManager *windowManager;

- (IBAction)openBrowser:(id)sender;

@end
