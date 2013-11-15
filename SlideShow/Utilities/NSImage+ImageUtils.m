//
//  NSImage+ImageUtils.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 02.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "NSImage+ImageUtils.h"

@implementation NSImage (ImageUtils)

- (NSBitmapImageRep*)largestBitmap {
    long maxPixelCount = 0;
    NSBitmapImageRep *largest = nil;
    for (NSImageRep *imageRep in [self representations]) {
        if ( [imageRep isKindOfClass:[NSBitmapImageRep class]] ) {
            long pixelCount = (long)imageRep.pixelsHigh * (long)imageRep.pixelsWide;
            if ( pixelCount > maxPixelCount || largest == nil ) {
                maxPixelCount = pixelCount;
                largest = (NSBitmapImageRep*)imageRep;
            }
        }
    }
    return largest;
}

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

- (IntegralSize)sizeInPixels {
    NSImageRep *largestImageRep = [self largestImageRep];
    return MakeIntegralSize(largestImageRep.pixelsWide, largestImageRep.pixelsHigh);
}

@end
