//
//  SSWindowManager.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSWindowManager.h"
#import "SSAppDelegate.h"
#import "SSImageBrowserWindow.h"

@implementation SSWindowManager

- (id)init {
    if ( self = [super init] ) {
        self.imageBrowsers = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (SSImageBrowserWindow*)openImageBrowserWithBaseDirectoryURL:(NSURL*)baseDirectory {
    NSLog(@"openImageBrowserWithBaseDirectoryURL: %@ start", baseDirectory.path);
    SSImageBrowserWindow *imageBrowser = [[SSImageBrowserWindow alloc] init];
    imageBrowser.manager = self;

    NSLog(@"openImageBrowserWithBaseDirectoryURL: %@ showWindow", baseDirectory.path);
    [imageBrowser showWindow:self];
    
    NSLog(@"openImageBrowserWithBaseDirectoryURL: %@ set baseDirectory", baseDirectory.path);
    if ( baseDirectory ) {
        imageBrowser.baseDirectoryURL = baseDirectory;
        [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:baseDirectory];
    }
    
    [self.imageBrowsers addObject:imageBrowser];
    return imageBrowser;
}

- (void)removeImageBrowser:(SSImageBrowserWindow*)imageBrowser {
    [self.imageBrowsers removeObject:imageBrowser];
}

+ (void)restoreWindowWithIdentifier:(NSString *)identifier state:(NSCoder *)state completionHandler:(void (^)(NSWindow *, NSError *))completionHandler {
    if ( [identifier isEqualToString:ID_IMAGE_BROWSER] ) {
        SSImageBrowserWindow *imageBrowser = [[self mainWindowManager] openImageBrowserWithBaseDirectoryURL:nil];
        completionHandler(imageBrowser.window, nil);
    }
}

+ (SSWindowManager*)mainWindowManager {
    SSAppDelegate *appDelegate = [NSApp delegate];
    return appDelegate.windowManager;
}

@end
