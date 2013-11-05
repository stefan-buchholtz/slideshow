//
//  SSDirectoryTreeDataSource.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSDirectoryTreeDataSource.h"

#import "SSDirectory.h"

@interface SSDirectoryTreeDataSource ()

- (SSDirectory*)directoryForTreeItem:(id)item;

- (NSArray*)sortedEntriesForDirectory:(SSDirectory*)directory;

@end

@implementation SSDirectoryTreeDataSource

- (id)initWithBaseDirectory:(SSDirectory*)directory {
    if ( self = [super init] ) {
        self.baseDirectory = directory;
        sortedEntries = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if ( item == nil ) {
        return self.baseDirectory;
    } else {
        NSArray *children = [self sortedEntriesForDirectory:item];
        return [children objectAtIndex:index];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    SSDirectory *directory = [self directoryForTreeItem:item];
    return directory.subDirectories.count > 0;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if ( item == nil ) {
        return self.baseDirectory ? 1 : 0;
    } else {
        return [item subDirectories].count;
    }
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    return [item name];
}

- (SSDirectory*)directoryForTreeItem:(id)item {
    return (item != nil) ? item : self.baseDirectory;
}

- (NSArray*)sortedEntriesForDirectory:(SSDirectory*)directory {
    NSArray *result = [sortedEntries objectForKey:directory];
    if ( result == nil ) {
        result = [[directory.subDirectories allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        [sortedEntries setObject:result forKey:directory];
    }
    return result;
}


@end
