//
//  SSIsSupportedFileChecker.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SSIsSupportedFileProtocol.h"

@interface SSSupportedFileChecker : NSObject <SSIsSupportedFileProtocol>

@property (strong) NSSet *supportedFileTypes;

- (BOOL)isSupportedFile:(NSURL*)file;

@end
