//
//  NSArray+SortedArrayWithKey.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 04.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "NSArray+SortedArrayWithKey.h"

@implementation NSArray (SortedArrayUsingKey)

- (NSArray*)sortedArrayWithKey:(NSString *)key ascending:(BOOL)ascending {
    return [self sortedArrayUsingDescriptor:[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending]];
}

- (NSArray*)sortedArrayUsingDescriptor:(NSSortDescriptor *)sortDescriptor {
    return [self sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

@end
