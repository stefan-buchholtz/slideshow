//
//  SSWindowManager.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSImageBrowserWindow;

@interface SSWindowManager : NSObject <NSWindowRestoration>

@property (strong) NSMutableArray *imageBrowsers;

- (SSImageBrowserWindow*)openImageBrowserWithBaseDirectoryURL:(NSURL*)baseDirectory;

- (void)removeImageBrowser:(SSImageBrowserWindow*)imageBrowser;

+ (SSWindowManager*)mainWindowManager;

// handle window restoration
+ (void)restoreWindowWithIdentifier:(NSString *)identifier state:(NSCoder *)state completionHandler:(void (^)(NSWindow *, NSError *))completionHandler;

@end
