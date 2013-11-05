//
//  SSFileSystemItem.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSFileSystemItem.h"

@implementation SSFileSystemItem

- (id)initWithURL:(NSURL*)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (NSString*)name {
    if ( !_name ) {
        _name = [[NSFileManager defaultManager] displayNameAtPath:self.url.path];
    }
    return _name;
}

- (NSString*)fullName {
    if ( !_fullName ) {
        if ( _parent ) {
            _fullName = [_parent.fullName stringByAppendingFormat:@"/%@", self.name];
        } else {
            _fullName = self.name;
        }
    }
    return _fullName;
}

- (NSString*)stringValue {
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0, count = [self level]; i < count; ++i) {
        [result appendString:@"  "];
    }
    [result appendString:[self.url path]];
    [result appendString:@"\n"];
    return result;
}

- (int)level {
    int result = 0;
    SSFileSystemItem *item = self;
    while ( (item = item.parent) != nil) {
        ++result;
    }
    return result;
}

@end
