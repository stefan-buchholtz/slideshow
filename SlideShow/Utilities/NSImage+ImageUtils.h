//
//  NSImage+ImageUtils.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 02.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GeometryFunctions.h"

@interface NSImage (ImageUtils)

- (NSBitmapImageRep*)largestBitmap;

- (NSImageRep*)largestImageRep;

- (IntegralSize)sizeInPixels;

@end
