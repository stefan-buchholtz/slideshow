//
//  SSImageView.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 02.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
    CUSTOM, TO_FIT, ACTUAL_SZIZE_OR_FIT
} ZoomState;

@interface SSImageView : NSView {
    NSSize              imageSize;
    ZoomState           zoomState;
}

@property (nonatomic, strong) NSImage   *image;
@property (nonatomic, strong) NSURL     *imageURL;
@property (nonatomic, strong) NSColor   *backgroundColor;
@property (nonatomic, assign) CGFloat   zoomFactor;
@property (nonatomic, assign) BOOL      displayImagePath;
@property (nonatomic, assign) BOOL      displayZoomFactor;

- (NSSize)zoomedImageSize;

- (void)zoomToFit:(id)sender;

- (void)zoomIn:(id)sender;

- (void)zoomOut:(id)sender;

- (void)zoomToActualSize:(id)sender;

- (void)zoomToActualSizeOrFit:(id)sender;

@end
