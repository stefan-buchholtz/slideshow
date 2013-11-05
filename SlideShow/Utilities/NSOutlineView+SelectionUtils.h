//
//  NSOutlineView+SelectionUtils.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 04.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSOutlineView (SelectionUtils)

- (void)selectItem:(id)item;

- (void)selectItems:(NSArray*)items;

@end
