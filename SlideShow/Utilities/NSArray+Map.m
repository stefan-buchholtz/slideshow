//
//  NSArray+Map.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 28.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "NSArray+Map.h"

@implementation NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:block(obj, idx)];
    }];
    return result;
}

@end
