//
//  SSSlideShowWindowWindowController.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 02.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SSImageView;
@class SSWindowManager;

@interface SSSlideShowWindowController : NSWindowController {
    int imageCount;
}

@property (weak) SSWindowManager        *manager;

@property (readonly, strong) NSArray    *imageList;
@property (readonly, assign) BOOL       orderByDirectory;
@property (nonatomic, assign) int       position;
@property (assign) BOOL                 wrapAround;

@property (weak) IBOutlet NSScrollView  *scrollView;
@property (weak) IBOutlet SSImageView   *imageView;
@property (strong) IBOutlet NSWindow    *overlayWindow;
@property (weak) IBOutlet NSTextField   *imageNameField;
@property (weak) IBOutlet NSTextField   *zoomFactorField;

- (id)initWithImageList:(NSSet *)imageFiles orderByDirectory:(BOOL)orderByDirectory;

- (IBAction)forward:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)first:(id)sender;
- (IBAction)last:(id)sender;
- (IBAction)zoomToFit:(id)sender;
- (IBAction)zoomToActualSize:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

@end
