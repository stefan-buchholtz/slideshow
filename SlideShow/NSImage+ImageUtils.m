//
//  NSImage+ImageUtils.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 02.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "NSImage+ImageUtils.h"

@implementation NSImage (ImageUtils)

- (NSImageRep*)largestImageRep {
    long maxPixelCount = 0;
    NSImageRep *largest = nil;
    for (NSImageRep *imageRep in [self representations]) {
        long pixelCount = (long)imageRep.pixelsHigh * (long)imageRep.pixelsWide;
        if ( pixelCount > maxPixelCount || largest == nil ) {
            maxPixelCount = pixelCount;
            largest = imageRep;
        }
    }
    return largest;
}

- (NSSize)sizeInPixels {
    NSImageRep *largestImageRep = [self largestImageRep];
    return NSMakeSize(largestImageRep.pixelsWide, largestImageRep.pixelsHigh);
}

@end
