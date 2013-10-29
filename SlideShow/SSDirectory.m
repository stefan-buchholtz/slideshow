//
//  SSDirectory.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSFile.h"
#import "SSDirectory.h"

const int INITIAL_CAPACITY = 10;

@implementation SSDirectory

- (id)initWithURL:(NSURL*)url {
    if (self = [super initWithURL:url]) {
        self.files = [[NSMutableSet alloc] init];
        self.subDirectories = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)addFilesObject:(SSFile *)file {
    file.parent = self;
    [(NSMutableSet*)self.files addObject:file];
}

- (void)addSubDirectoriesObject:(SSDirectory *)subDirectory {
    subDirectory.parent = self;
    [(NSMutableSet*)self.subDirectories addObject:subDirectory];
}

- (BOOL)hasItems {
    return self.files.count > 0 || self.subDirectories.count > 0;
}

- (NSString*)stringValue {
    NSMutableString *result = [NSMutableString stringWithString:[super stringValue]];
    for (SSDirectory *directory in self.subDirectories) {
        [result appendString:[directory stringValue]];
    }
    for (SSFile *file in self.files) {
        [result appendString:[file stringValue]];
    }
    return result;
}


@end
