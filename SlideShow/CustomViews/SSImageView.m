//
//  SSImageView.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 02.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSImageView.h"

#import "NSImage+ImageUtils.h"
#import "GeometryFunctions.h"

typedef enum {
    UP, DOWN
} ScrollDirection;

@interface SSImageView ()

- (void)didInit;

- (void)loadImage;

- (NSSize)containerSize;

- (void)updateViewSize;

- (void)calculateZoomToFit;

- (NSScrollView*)findSuperiorScrollView;

- (void)frameDidChange:(NSNotification*)notification;

- (void)scrollVertical:(ScrollDirection)direction;

@end

@implementation SSImageView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self didInit];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [self didInit];
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
    NSSize imgSize = [self zoomedImageSize];
    NSRect viewRect = self.bounds;
    NSRect imgRect;
    if ( viewRect.size.width > imgSize.width || viewRect.size.height > imgSize.height ) {
        if ( _backgroundColor ) {
            [_backgroundColor set];
            [NSBezierPath fillRect:viewRect];
        }
        imgRect.size = imgSize;
        imgRect.origin.x = (viewRect.size.width > imgSize.width) ? (viewRect.size.width - imgSize.width) / 2.0 : 0.0;
        imgRect.origin.y = (viewRect.size.height > imgSize.height) ? (viewRect.size.height - imgSize.height) / 2.0 : 0.0;
    } else {
        imgRect = viewRect;
    }
    if ( _image ) {
        [_image drawInRect:imgRect fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
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

- (void)scrollLineDown:(id)sender {
    [self scrollVertical:DOWN];
}

- (void)scrollLineUp:(id)sender {
    [self scrollVertical:UP];
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

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    if ( _backgroundColor != backgroundColor ) {
        _backgroundColor = backgroundColor;
        [self setNeedsDisplay:YES];
    }
}

#pragma mark private methods
- (void)didInit {
    _zoomFactor = 1.0;
    isZoomedToFit = YES;
    NSView *scrollView = [self findSuperiorScrollView];
    if ( scrollView ) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameDidChange:) name:NSViewFrameDidChangeNotification object:scrollView];
    }
}

- (void)loadImage {
    if ( _image ) {
        imageSize = IntegralSizeToNSSize([_image sizeInPixels]);
        if ( isZoomedToFit ) {
            [self calculateZoomToFit];
        }
        [self updateViewSize];
    }
}

- (void)updateViewSize {
    NSRect frame = self.frame;
    frame.size = MaxSize([self zoomedImageSize], [self containerSize]);
    self.frame = frame;
    [self setNeedsDisplay:YES];
}

- (NSSize)containerSize {
    NSScrollView *scrollView = [self findSuperiorScrollView];
    if ( scrollView ) {
        return scrollView.bounds.size;
    } else {
        return NSMakeSize(0.0, 0.0);
    }
}

- (void)calculateZoomToFit {
    CGFloat factor = 1.0;
    if ( _image ) {
        NSSize viewSize = [self containerSize];
        if ( imageSize.height > 0.0 && imageSize.width > 0.0 && viewSize.width > 0.0 && viewSize.height > 0.0 ) {
            float xFactor = viewSize.width / imageSize.width;
            float yFactor = viewSize.height / imageSize.height;
            factor = xFactor > yFactor ? yFactor : xFactor;
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
    while ( view && ![view isKindOfClass:[NSScrollView class]]) {
        view = [view superview];
    }
    return (NSScrollView*)view;
}

- (void)frameDidChange:(NSNotification*)notification {
    if ( isZoomedToFit ) {
        [self zoomToFit:self];
    }
}

- (void)scrollVertical:(ScrollDirection)direction {
    NSSize imgSize = [self zoomedImageSize];
    NSScrollView *scrollView = [self findSuperiorScrollView];
    
    float scrollAmount = round((imgSize.height - scrollView.bounds.size.height) / 10.0);
    if ( scrollAmount < 0.0 ) {
        return;
    }
    
    NSPoint scrollPoint = scrollView.contentView.bounds.origin;
    if ( direction == UP ) {
        scrollPoint.y += scrollAmount;
    } else {
        scrollPoint.y -= scrollAmount;
    }
    [self scrollPoint:scrollPoint];
    
}

@end
