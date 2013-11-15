//
//  GeometryFunctions.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 04.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#ifndef SlideShow_GeometryFunctions_h
#define SlideShow_GeometryFunctions_h

#import <Foundation/Foundation.h>

struct IntegralSize {
    NSUInteger width;
    NSUInteger height;
};
typedef struct  IntegralSize  IntegralSize;

IntegralSize MakeIntegralSize(NSUInteger width, NSUInteger height);

IntegralSize MaxIntegralSize(IntegralSize s1, IntegralSize s2);

NSSize IntegralSizeToNSSize(IntegralSize size);

IntegralSize NSSizeToIntegralSize(NSSize size);

NSSize MaxSize(NSSize s1, NSSize s2);

#endif
