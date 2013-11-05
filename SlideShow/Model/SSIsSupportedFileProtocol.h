//
//  SSIsFileTypeSupportedProtocol.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSIsSupportedFileProtocol <NSObject>

- (BOOL)isSupportedFile:(NSURL*)file;

@end
