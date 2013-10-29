//
//  SSFileSystemItem.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSFileSystemItem : NSObject

@property (strong) NSURL *url;
@property (weak) SSFileSystemItem *parent;

- (id)initWithURL:(NSURL*)url;

- (NSString*)name;

- (NSString*)stringValue;

- (int)level;

@end
