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

- (void)awakeFromNib {
    self.windowManager = [[SSWindowManager alloc] init];    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
    NSURL *url = [[NSURL alloc] initFileURLWithPath:filename];
    NSNumber *isDirectory;
    [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
    if ( isDirectory.boolValue ) {
        [self.windowManager openImageBrowserWithBaseDirectoryURL:url];
        return YES;
    } else {
        return NO;
    }
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
