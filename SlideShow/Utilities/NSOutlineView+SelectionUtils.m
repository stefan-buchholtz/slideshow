//
//  NSOutlineView+SelectionUtils.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 04.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "NSOutlineView+SelectionUtils.h"

@implementation NSOutlineView (SelectionUtils)

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
