//
//  SSWindowManager.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSImageBrowserWindow;

@interface SSWindowManager : NSObject

@property (strong) NSMutableArray *imageBrowsers;

- (SSImageBrowserWindow*)openImageBrowserWithBaseDirectoryURL:(NSURL*)baseDirectory;

- (void)removeImageBrowser:(SSImageBrowserWindow*)imageBrowser;

@end
