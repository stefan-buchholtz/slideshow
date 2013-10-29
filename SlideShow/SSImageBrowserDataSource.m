//
//  SSImageBrowserDataSource.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 28.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSImageBrowserDataSource.h"

#import "SSDirectory.h"
#import "NSArray+Map.h"
#import "SSImageBrowserItem.h"

@interface SSImageBrowserDataSource ()

- (void)reloadImages;

@end

@implementation SSImageBrowserDataSource

- (void)setDirectory:(SSDirectory *)directory {
    if ( _directory != directory ) {
        _directory = directory;
        [self reloadImages];
    }
}

- (void)reloadImages {
    if ( self.directory ) {
        NSArray *sortedFiles = [[self.directory.files allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];

        imageItems = [sortedFiles mapObjectsUsingBlock:^id(id file, NSUInteger idx) {
            return [[SSImageBrowserItem alloc] initWithFile:file];
        }];
    } else {
        imageItems = nil;
    }
    [self.imageBrowser reloadData];
}

- (NSUInteger)numberOfItemsInImageBrowser:(IKImageBrowserView *)imageBrowser {
    return imageItems ? imageItems.count : 0;
}

- (id)imageBrowser:(IKImageBrowserView *)imageBrowser itemAtIndex:(NSUInteger)index {
    return imageItems ? [imageItems objectAtIndex:index] : nil;
}

@end
