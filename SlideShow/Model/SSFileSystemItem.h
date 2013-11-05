//
//  SSFileSystemItem.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSFileSystemItem : NSObject {
    NSString *_name;
    NSString *_fullName;
}

@property (strong) NSURL *url;
@property (weak) SSFileSystemItem *parent;

- (id)initWithURL:(NSURL*)url;

- (NSString*)name;

- (NSString*)fullName;

- (NSString*)stringValue;

- (int)level;

@end
