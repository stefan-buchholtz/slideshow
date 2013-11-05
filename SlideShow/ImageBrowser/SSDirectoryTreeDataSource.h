//
//  SSDirectoryTreeDataSource.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSDirectory;

@interface SSDirectoryTreeDataSource : NSObject <NSOutlineViewDataSource> {
    NSMapTable *sortedEntries;
}

@property (strong) SSDirectory* baseDirectory;

- (id)initWithBaseDirectory:(SSDirectory*)directory;

@end
