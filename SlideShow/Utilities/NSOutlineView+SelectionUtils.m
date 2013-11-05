//
//  NSOutlineView+SelectionUtils.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 04.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "NSOutlineView+SelectionUtils.h"

@implementation NSOutlineView (SelectionUtils)

- (id)selectedItem {
    return [self itemAtRow:[self selectedRow]];
}

- (NSArray*)selectedItems {
    NSIndexSet *selectedRowIndexes = self.selectedRowIndexes;
    NSMutableArray *selectedItems = [[NSMutableArray alloc] initWithCapacity:selectedRowIndexes.count];
    [selectedRowIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [selectedItems addObject:[self itemAtRow:idx]];
    }];
    return selectedItems;
}

- (void)selectItem:(id)item {
    [self selectItems:@[item]];
}

- (void)selectItems:(NSArray*)items {
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    for (id item in items) {
        NSInteger rowIndex = [self rowForItem:item];
        if ( rowIndex >= 0 ) {
            [indexSet addIndex:rowIndex];
        }
    }
    [self selectRowIndexes:indexSet byExtendingSelection:NO];
}

@end
