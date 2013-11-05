//
//  SSImageBrowserItem.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 28.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSFileSystemItem;
@class SSFile;

@interface SSImageBrowserItem : NSObject

@property (strong) SSFileSystemItem *file;
@property (readonly) BOOL           isImage;

- (id)initWithFile:(SSFileSystemItem*)file;

- (NSString *)imageUID;

- (NSString *) imageRepresentationType;

- (id)imageRepresentation;

- (NSString *) imageTitle;

@end
