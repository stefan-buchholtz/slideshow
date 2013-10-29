//
//  SSAppDelegate.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSAppDelegate.h"

#import "SSWindowManager.h"

@interface SSAppDelegate ()

- (NSURL *)showDirectoryOpenPanel;

@end

@implementation SSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.windowManager = [[SSWindowManager alloc] init];
}

- (IBAction)openBrowser:(id)sender {
    NSURL *baseDirectory = [self showDirectoryOpenPanel];
    if ( baseDirectory ) {
        [self.windowManager openImageBrowserWithBaseDirectoryURL:baseDirectory];
    }
}

#pragma mark private methods
- (NSURL *)showDirectoryOpenPanel {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowsMultipleSelection = NO;
    openPanel.canChooseFiles = NO;
    openPanel.canChooseDirectories = YES;
    if ( [openPanel runModal] == NSFileHandlingPanelOKButton ) {
        return openPanel.URL;
    } else {
        return nil;
    }
}


@end
