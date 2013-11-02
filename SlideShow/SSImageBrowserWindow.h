//
//  SSImageBrowserControllerWindowController.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Quartz/Quartz.h>
#import <Cocoa/Cocoa.h>

static NSString *const ID_IMAGE_BROWSER = @"imageBrowser";

@class SSWindowManager;
@class SSDirectory;
@class SSDirectoryTreeDataSource;
@class SSImageBrowserDataSource;
@class SSImageView;

@interface SSImageBrowserWindow : NSWindowController <NSWindowDelegate, NSToolbarDelegate> {
    SSDirectoryTreeDataSource   *directoryTreeDataSource;
    NSOperationQueue            *backgroundTaskQueue;
    NSInvocationOperation       *loadDirectoryTreeOperation;
}

@property (weak) SSWindowManager *manager;

@property (strong) SSDirectory *baseDirectory;
@property (nonatomic, strong) NSURL *baseDirectoryURL;
@property (nonatomic, assign) float thumbnailZoom;

@property (strong) IBOutlet SSImageBrowserDataSource *imageBrowserDataSource;
@property (weak) IBOutlet NSOutlineView *directoryTreeView;
@property (weak) IBOutlet IKImageBrowserView *directoryContentsView;
@property (weak) IBOutlet SSImageView *imageView;
@property (weak) IBOutlet NSScrollView *imageScrollView;
@property (weak) IBOutlet NSProgressIndicator *spinner;
@property (weak) IBOutlet NSSlider *thumbnailZoomSlider;
@property (weak) IBOutlet NSSegmentedControl *zoomButtonGroup;

// window delegate methods
- (void)windowWillClose:(NSNotification *)notification;

// outline view delegate methods
- (void)outlineViewSelectionDidChange:(NSNotification *)notification;
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item;

- (IBAction)clickedZoomButton:(id)sender;
- (IBAction)startSlideshow:(id)sender;

@end
