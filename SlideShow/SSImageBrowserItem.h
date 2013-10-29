//
//  SSImageBrowserItem.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 28.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSFile;

@interface SSImageBrowserItem : NSObject

@property (strong) SSFile *file;

- (id)initWithFile:(SSFile*)file;

- (NSString *)imageUID;

- (NSString *) imageRepresentationType;

- (id)imageRepresentation;

- (NSString *) imageTitle;

@end
