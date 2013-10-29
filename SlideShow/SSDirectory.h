//
//  SSDirectory.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSFileSystemItem.h"

@class SSFile;

@interface SSDirectory : SSFileSystemItem

@property (strong) NSSet *files;
@property (strong) NSSet *subDirectories;

- (void)addFilesObject:(SSFile *)file;

- (void)addSubDirectoriesObject:(SSDirectory *)subDirectory;

- (BOOL)hasItems;

@end
