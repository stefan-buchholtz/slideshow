//
//  GeometryFunctions.c
//  SlideShow
//
//  Created by Stefan Buchholtz on 04.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#include "GeometryFunctions.h"

IntegralSize MakeIntegralSize(NSUInteger width, NSUInteger height) {
    IntegralSize result;
    result.width = width;
    result.height = height;
    return result;
}

IntegralSize MaxIntegralSize(IntegralSize s1, IntegralSize s2) {
    return MakeIntegralSize(s1.width > s2.width ? s1.width : s2.width, s1.height > s2.height ? s1.height : s2.height);
}

NSSize IntegralSizeToNSSize(IntegralSize size) {
    return NSMakeSize(size.width, size.height);
}

IntegralSize NSSizeToIntegralSize(NSSize size) {
    return MakeIntegralSize(round(size.width), round(size.height));
}

NSSize MaxSize(NSSize s1, NSSize s2) {
    return NSMakeSize(s1.width > s2.width ? s1.width : s2.width, s1.height > s2.height ? s1.height : s2.height);
}

