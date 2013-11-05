//
//  SSIsSupportedFileChecker.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSSupportedFileChecker.h"

@implementation SSSupportedFileChecker

- (id)init {
    if ( self = [super init] ) {
        self.supportedFileTypes = [NSSet setWithObjects:@"jpg", @"jpeg", @"png", nil];
    }
    return self;
}

- (BOOL)isSupportedFile:(NSURL*)file {
    NSString *ext = [file.pathExtension lowercaseString];
    return [self.supportedFileTypes member:ext] != nil;
}


@end
