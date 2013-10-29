//
//  SSImageBrowserControllerWindowController.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSImageBrowserWindow.h"

#import "SSWindowManager.h"
#import "SSFile.h"
#import "SSDirectory.h"
#import "SSDirectoryWalker.h"
#import "SSSupportedFileChecker.h"
#import "SSDirectoryTreeDataSource.h"
#import "SSImageBrowserDataSource.h"
#import "SSImageBrowserItem.h"

@interface SSImageBrowserWindow ()

- (void)setWindowTitle;

- (void)loadImageDirectoryTreeAsync;

- (SSDirectory*)loadImageDirectoryTree:(NSURL*)baseDirectory;

- (void)loadedDirectoryTree:(SSDirectory*)directory;

- (void)displayImageFile:(SSFile*)imageFile;

- (void)displayImageURL:(NSURL*)imageURL;

- (void)imageViewFrameChanged:(NSNotification *)notification;

@end

@implementation SSImageBrowserWindow

- (id)initWithBaseDirectoryURL:(NSURL *)baseDirectoryURL {
    if (self = [super initWithWindowNibName:@"SSImageBrowserWindow"]) {
        self.baseDirectoryURL = baseDirectoryURL;
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self setWindowTitle];
    
    [self.spinner startAnimation:self];
    [self loadImageDirectoryTreeAsync];
    
    self.directoryContentsView.cellsStyleMask = IKCellsStyleShadowed | IKCellsStyleTitled;
    self.directoryContentsView.allowsMultipleSelection = YES;
    self.directoryContentsView.allowsEmptySelection = YES;
    self.directoryContentsView.allowsReordering = NO;
}

- (void)awakeFromNib {
    NSString *dummyImagePath = [[NSBundle mainBundle] pathForResource: @"dummyImg" ofType: @"png"];
    [self displayImageURL:[NSURL fileURLWithPath: dummyImagePath]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageViewFrameChanged:) name:NSViewFrameDidChangeNotification object:self.imageView];
    [self.window zoom:self];
}

#pragma mark private methods
- (void)setWindowTitle {
    NSArray *pathComponents = [[NSFileManager defaultManager] componentsToDisplayForPath:self.baseDirectoryURL.path];
    self.window.title = [pathComponents componentsJoinedByString:@"/"];
}

- (void)loadImageDirectoryTreeAsync {
    loadDirectoryTreeOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImageDirectoryTree:) object:self.baseDirectoryURL];
    SSImageBrowserWindow * __weak wSelf = self;
    NSInvocationOperation * __weak wOperation = loadDirectoryTreeOperation;
    loadDirectoryTreeOperation.completionBlock = ^{
        [wSelf performSelectorOnMainThread:@selector(loadedDirectoryTree:) withObject:wOperation.result waitUntilDone:false];
    };
    
    backgroundTaskQueue = [[NSOperationQueue alloc] init];
    [backgroundTaskQueue addOperation:loadDirectoryTreeOperation];
}

- (SSDirectory*)loadImageDirectoryTree:(NSURL*)baseDirectory {
    SSDirectoryWalker *dirWalker = [[SSDirectoryWalker alloc] init];
    SSSupportedFileChecker *fileChecker = [[SSSupportedFileChecker alloc] init];
    dirWalker.supportedFileChecker = fileChecker;
    return [dirWalker findImagesInDirectory:baseDirectory];
}

- (void)loadedDirectoryTree:(SSDirectory*)directory {
    self.baseDirectory = directory;
    directoryTreeDataSource = [[SSDirectoryTreeDataSource alloc] initWithBaseDirectory:self.baseDirectory];
    self.directoryTreeView.dataSource = directoryTreeDataSource;
    [self.spinner stopAnimation:self];
}

- (void)displayImageFile:(SSFile*)imageFile {
    [self displayImageURL:imageFile.url];
}

- (void)displayImageURL:(NSURL*)imageURL {
    [self.imageView setImageWithURL:imageURL];
    [self.imageView setCurrentToolMode:IKToolModeNone];
    [self.imageView zoomImageToFit:self];
}

#pragma mark window delegate methods
// window delegate methods
- (void)windowWillClose:(NSNotification *)notification {
    [self.manager removeImageBrowser:self];
}

#pragma mark outline view delegate methods
// outline view delegate methods
- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    self.imageBrowserDataSource.directory = [self.directoryTreeView itemAtRow:[self.directoryTreeView selectedRow]];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    return NO;
}

#pragma mark image browser delegate methods
- (void)imageBrowserSelectionDidChange:(IKImageBrowserView *)imageBrowser {
    NSUInteger selectedIndex = [[imageBrowser selectionIndexes] firstIndex];
    if ( selectedIndex != NSNotFound ) {
        SSImageBrowserItem *selectedItem = [self.imageBrowserDataSource imageBrowser:imageBrowser itemAtIndex:selectedIndex];
        [self displayImageFile:selectedItem.file];
    }
}

#pragma mark image view notification methods
- (void)imageViewFrameChanged:(NSNotification *)notification {
    [self.imageView zoomImageToFit:self];
}


@end
