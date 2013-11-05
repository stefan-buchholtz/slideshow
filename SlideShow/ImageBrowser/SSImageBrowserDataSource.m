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
#import "NSArray+SortedArrayWithKey.h"
#import "SSImageBrowserItem.h"

@interface SSImageBrowserDataSource ()

- (void)reloadImages;

@end

@implementation SSImageBrowserDataSource

#pragma mark property getters/setters
- (void)setDirectories:(NSArray *)directories {
    if ( _directories != directories ) {
        _directories = directories;
        [self reloadImages];
    }
}

- (void)setShowImagesInSubDirectories:(BOOL)showImagesInSubDirectories {
    if ( _showImagesInSubDirectories != showImagesInSubDirectories ) {
        _showImagesInSubDirectories = showImagesInSubDirectories;
        [self reloadImages];
    }
}

- (void)setSortOrderByDirectory:(BOOL)sortOrderByDirectory {
    if ( _sortOrderByDirectory != sortOrderByDirectory ) {
        _sortOrderByDirectory = sortOrderByDirectory;
        [self reloadImages];
    }
}

#pragma mark private methods
- (void)reloadImages {
    if ( _directories && _directories.count > 0 ) {
        NSMutableArray *files = [[NSMutableArray alloc] init];
        for (SSDirectory *directory in _directories) {
            if ( _showImagesInSubDirectories ) {
                [files addObjectsFromArray:[directory.allFiles allObjects]];
            } else {
                [files addObjectsFromArray:[directory.files allObjects]];
                [files addObjectsFromArray:[directory.subDirectories allObjects]];
            }
        }
        NSArray *sortedFiles = [files naturallySortedArrayWithKey:(_sortOrderByDirectory ? @"fullName" : @"name") ascending:YES];

        imageItems = [sortedFiles mapObjectsUsingBlock:^id(id file, NSUInteger idx) {
            return [[SSImageBrowserItem alloc] initWithFile:file];
        }];
    } else {
        imageItems = nil;
    }
    [self.imageBrowser reloadData];
}

#pragma mark ImageBrowser dataSource methods
- (NSUInteger)numberOfItemsInImageBrowser:(IKImageBrowserView *)imageBrowser {
    return imageItems ? imageItems.count : 0;
}

- (id)imageBrowser:(IKImageBrowserView *)imageBrowser itemAtIndex:(NSUInteger)index {
    return imageItems ? [imageItems objectAtIndex:index] : nil;
}

@end
