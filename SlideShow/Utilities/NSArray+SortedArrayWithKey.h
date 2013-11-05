//
//  NSArray+SortedArrayWithKey.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 04.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SortedArrayUsingKey)

- (NSArray*)naturallySortedArrayWithKey:(NSString *)key ascending:(BOOL)ascending;

- (NSArray*)sortedArrayWithKey:(NSString *)key ascending:(BOOL)ascending;

- (NSArray*)sortedArrayUsingDescriptor:(NSSortDescriptor *)sortDescriptor;

@end
