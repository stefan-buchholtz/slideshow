//
//  SSImageBrowserControllerWindowController.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Quartz/Quartz.h>
#import <Cocoa/Cocoa.h>

@class SSWindowManager;
@class SSDirectory;
@class SSDirectoryTreeDataSource;
@class SSImageBrowserDataSource;

@interface SSImageBrowserWindow : NSWindowController <NSWindowDelegate> {
    SSDirectoryTreeDataSource *directoryTreeDataSource;
    NSOperationQueue *backgroundTaskQueue;
    NSInvocationOperation *loadDirectoryTreeOperation;
}

@property (weak) SSWindowManager *manager;

@property (strong) SSDirectory *baseDirectory;
@property (strong) NSURL *baseDirectoryURL;

@property (strong) IBOutlet SSImageBrowserDataSource *imageBrowserDataSource;
@property (weak) IBOutlet NSOutlineView *directoryTreeView;
@property (weak) IBOutlet IKImageBrowserView *directoryContentsView;
@property (weak) IBOutlet IKImageView *imageView;
@property (weak) IBOutlet NSProgressIndicator *spinner;

- (id)initWithBaseDirectoryURL:(NSURL *)baseDirectoryURL;

// window delegate methods
- (void)windowWillClose:(NSNotification *)notification;

// outline view delegate methods
- (void)outlineViewSelectionDidChange:(NSNotification *)notification;
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item;


@end
