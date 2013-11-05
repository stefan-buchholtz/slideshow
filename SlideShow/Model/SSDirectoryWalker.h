//
//  SSDirectoryWalker.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SSIsSupportedFileProtocol.h"

@class SSDirectory;

@interface SSDirectoryWalker : NSObject {
    NSArray *urlProperties;
}

@property (weak) id<SSIsSupportedFileProtocol> supportedFileChecker;

- (SSDirectory*)findImagesInDirectory:(NSURL*)directoryURL;

@end
