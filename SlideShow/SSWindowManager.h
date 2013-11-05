//
//  SSWindowManager.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSImageBrowserWindow;
@class SSSlideShowWindowController;

@interface SSWindowManager : NSObject <NSWindowRestoration>

@property (strong) NSMutableArray *imageBrowsers;
@property (strong) SSSlideShowWindowController *activeSlideShow;

- (SSImageBrowserWindow*)openImageBrowserWithBaseDirectoryURL:(NSURL*)baseDirectory;

- (void)removeImageBrowser:(SSImageBrowserWindow*)imageBrowser;

- (SSSlideShowWindowController*)startSlideShowWithImageFiles:(NSSet*)imageFiles orderByDirectory:(BOOL)orderByDirectory;

- (void)endSlideShow:(SSSlideShowWindowController*)slideShow;

+ (SSWindowManager*)mainWindowManager;

// handle window restoration
+ (void)restoreWindowWithIdentifier:(NSString *)identifier state:(NSCoder *)state completionHandler:(void (^)(NSWindow *, NSError *))completionHandler;

@end
