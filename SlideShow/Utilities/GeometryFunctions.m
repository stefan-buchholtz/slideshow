//
//  GeometryFunctions.c
//  SlideShow
//
//  Created by Stefan Buchholtz on 04.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#include "GeometryFunctions.h"

NSSize MaxSize(NSSize s1, NSSize s2) {
    return NSMakeSize(s1.width > s2.width ? s1.width : s2.width, s1.height > s2.height ? s1.height : s2.height);
}
