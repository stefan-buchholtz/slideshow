//
//  SSWindowManager.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSWindowManager.h"
#import "SSImageBrowserWindow.h"

@implementation SSWindowManager

- (id)init {
    if ( self = [super init] ) {
        self.imageBrowsers = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (SSImageBrowserWindow*)openImageBrowserWithBaseDirectoryURL:(NSURL*)baseDirectory {
    SSImageBrowserWindow *imageBrowser = [[SSImageBrowserWindow alloc] initWithBaseDirectoryURL:baseDirectory];
    imageBrowser.manager = self;
    [imageBrowser showWindow:self];
    [self.imageBrowsers addObject:imageBrowser];
    return imageBrowser;
}

- (void)removeImageBrowser:(SSImageBrowserWindow*)imageBrowser {
    [self.imageBrowsers removeObject:imageBrowser];
}

@end
