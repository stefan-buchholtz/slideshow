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
    BOOL                        displayingImage;
    NSArray                     *selectedDirectories;
    SSDirectoryTreeDataSource   *directoryTreeDataSource;
    NSOperationQueue            *backgroundTaskQueue;
    NSInvocationOperation       *loadDirectoryTreeOperation;
    NSArray                     *_treeViewSelectionPaths;
}

@property (weak) SSWindowManager *manager;

@property (strong) SSDirectory          *baseDirectory;
@property (nonatomic, strong) NSURL     *baseDirectoryURL;
@property (nonatomic, strong) NSArray   *treeViewSelectionPaths;
@property (nonatomic, assign) float     thumbnailZoom;
@property (nonatomic, assign) BOOL      showImagesInSubDirectories;
@property (nonatomic, assign) BOOL      sortOrderByDirectory;

@property (strong) IBOutlet SSImageBrowserDataSource    *imageBrowserDataSource;
@property (weak) IBOutlet NSOutlineView                 *directoryTreeView;
@property (weak) IBOutlet IKImageBrowserView            *directoryContentsView;
@property (weak) IBOutlet SSImageView                   *imageView;
@property (weak) IBOutlet NSScrollView                  *imageScrollView;
@property (weak) IBOutlet NSProgressIndicator           *spinner;
@property (weak) IBOutlet NSSlider                      *thumbnailZoomSlider;
@property (weak) IBOutlet NSSegmentedControl            *zoomButtonGroup;

// window delegate methods
- (void)windowWillClose:(NSNotification *)notification;

// outline view delegate methods
- (void)outlineViewSelectionDidChange:(NSNotification *)notification;
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item;

// actions
- (IBAction)clickedZoomButton:(id)sender;
- (IBAction)zoomToFit:(id)sender;
- (IBAction)zoomToActualSize:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;
- (IBAction)startSlideshow:(id)sender;
- (IBAction)showToolbarIcons:(id)sender;
- (IBAction)showToolbarText:(id)sender;
- (IBAction)showToolbarIconsAndText:(id)sender;
- (IBAction)toggleSortByFolder:(id)sender;
- (IBAction)toggleShowImagesInSubFolders:(id)sender;

@end
