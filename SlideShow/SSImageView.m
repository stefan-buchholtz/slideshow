//
//  SSImageView.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 02.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSImageView.h"

#import "NSImage+ImageUtils.h"

@interface SSImageView ()

- (void)loadImage;

- (void)updateViewSize;

- (NSSize)zoomedImageSize;

- (void)calculateZoomToFit;

- (NSScrollView*)findSuperiorScrollView;

@end

@implementation SSImageView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _zoomFactor = 1.0;
        isZoomedToFit = YES;
    }
    return self;
}

- (void)awakeFromNib {
    _zoomFactor = 1.0;
    isZoomedToFit = YES;    
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
    if ( _image ) {
        [_image drawInRect:self.bounds fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    }
}

- (BOOL)isFlipped {
    return NO;
}

- (BOOL)isOpaque {
    return YES;
}

#pragma mark public methods
- (void)zoomToFit:(id)sender {
    isZoomedToFit = YES;
    [self calculateZoomToFit];
    [self setNeedsDisplay:YES];
}

- (void)zoomIn:(id)sender {
    isZoomedToFit = NO;
    self.zoomFactor *= 1.5;
}

- (void)zoomOut:(id)sender {
    isZoomedToFit = NO;
    self.zoomFactor *= 2.0 / 3.0;
}

- (void)zoomToActualSize:(id)sender {
    isZoomedToFit = NO;
    self.zoomFactor = 1.0;
}

- (void)scrollToBeginningOfDocument:(id)sender {
    [self scrollPoint:NSMakePoint(0, self.frame.size.height)];
}

- (void)scrollToEndOfDocument:(id)sender {
    [self scrollPoint:NSMakePoint(0, 0)];
}


- (void)magnifyWithEvent:(NSEvent *)event {
    self.zoomFactor *= 1.0 + [event magnification];
}

#pragma mark property getters and setters
- (void)setImageURL:(NSURL *)imageURL {
    if ( _imageURL != imageURL ) {
        _imageURL = imageURL;
        self.image = [[NSImage alloc] initWithContentsOfURL:imageURL];
    }
}

- (void)setImage:(NSImage *)image {
    if ( _image != image ) {
        _image = image;
        [self loadImage];
    }
}

- (void)setZoomFactor:(CGFloat)zoomFactor {
    if ( _zoomFactor != zoomFactor ) {
        _zoomFactor = zoomFactor;
        [self updateViewSize];
    }
}

#pragma mark private methods
- (void)loadImage {
    if ( _image ) {
        imageSize = [_image sizeInPixels];
        if ( isZoomedToFit ) {
            [self calculateZoomToFit];
        }
        [self updateViewSize];
    }
}

- (void)updateViewSize {
    NSRect frame = self.frame;
    frame.size = [self zoomedImageSize];
    self.frame = frame;
    [self setNeedsDisplay:YES];
}


- (void)calculateZoomToFit {
    CGFloat factor = 1.0;
    if ( _image ) {
        NSScrollView *scrollView = [self findSuperiorScrollView];
        if ( scrollView ) {
            NSSize viewSize = scrollView.bounds.size;
            if ( imageSize.height > 0.0 && imageSize.width > 0.0 && viewSize.width > 0.0 && viewSize.height > 0.0 ) {
                float xFactor = viewSize.width / imageSize.width;
                float yFactor = viewSize.height / imageSize.height;
                factor = xFactor > yFactor ? yFactor : xFactor;
            }
        }
    }
    self.zoomFactor = factor;
}

- (NSSize)zoomedImageSize {
    if ( _image ) {
        return NSMakeSize(imageSize.width * _zoomFactor, imageSize.height * _zoomFactor);
    } else {
        return NSMakeSize(0.0, 0.0);
    }
}

- (NSScrollView*)findSuperiorScrollView {
    NSView *view = self.superview;
    while ( ![view isKindOfClass:[NSScrollView class]]) {
        view = [view superview];
    }
    return (NSScrollView*)view;
}

@end
