//
//  NSArray+SortedArrayWithKey.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 04.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "NSArray+SortedArrayWithKey.h"

static const NSStringCompareOptions NATURAL_COMPARE_OPTIONS = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;

@implementation NSArray (SortedArrayUsingKey)

- (NSArray*)naturallySortedArrayWithKey:(NSString *)key ascending:(BOOL)ascending {
    NSLocale *currentLocale = [NSLocale currentLocale];
    return [self sortedArrayUsingDescriptor:[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending comparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NATURAL_COMPARE_OPTIONS range:NSMakeRange(0, [obj1 length]) locale:currentLocale];
    }]];
}

- (NSArray*)sortedArrayWithKey:(NSString *)key ascending:(BOOL)ascending {
    return [self sortedArrayUsingDescriptor:[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending]];
}

- (NSArray*)sortedArrayUsingDescriptor:(NSSortDescriptor *)sortDescriptor {
    return [self sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

@end
