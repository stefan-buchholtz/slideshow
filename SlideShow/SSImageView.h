//
//  SSImageView.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 02.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SSImageView : NSView {
    NSSize              imageSize;
    BOOL                isZoomedToFit;
}

@property (nonatomic, strong) NSImage   *image;
@property (nonatomic, strong) NSURL     *imageURL;
@property (nonatomic, assign) CGFloat   zoomFactor;
@property (nonatomic, assign) BOOL      displayImagePath;
@property (nonatomic, assign) BOOL      displayZoomFactor;

- (void)zoomToFit:(id)sender;

- (void)zoomIn:(id)sender;

- (void)zoomOut:(id)sender;

- (void)zoomToActualSize:(id)sender;

@end
