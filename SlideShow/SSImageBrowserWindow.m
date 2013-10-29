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

- (void)baseDirectoryChanged;

- (void)setWindowTitle;

- (void)loadImageDirectoryTreeAsync;

- (SSDirectory*)loadImageDirectoryTree:(NSURL*)baseDirectory;

- (void)loadedDirectoryTree:(SSDirectory*)directory;

- (void)displayImageFile:(SSFile*)imageFile;

- (void)displayImageURL:(NSURL*)imageURL;

- (void)imageViewFrameChanged:(NSNotification *)notification;

@end

@implementation SSImageBrowserWindow

- (id)init {
    self = [super initWithWindowNibName:@"SSImageBrowserWindow"];
    return self;
}

- (void)windowDidLoad {
    NSLog(@"windowDidLoad");
    [super windowDidLoad];
    
    NSString *dummyImagePath = [[NSBundle mainBundle] pathForResource: @"dummyImg" ofType: @"png"];
    [self displayImageURL:[NSURL fileURLWithPath: dummyImagePath]];
}

- (void)awakeFromNib {
    NSLog(@"awakeFromNib");
    
    self.window.restorable = YES;
    self.window.restorationClass = [SSWindowManager class];
    self.window.identifier = ID_IMAGE_BROWSER;

    self.directoryContentsView.cellsStyleMask = IKCellsStyleShadowed | IKCellsStyleTitled;
    self.directoryContentsView.allowsMultipleSelection = YES;
    self.directoryContentsView.allowsEmptySelection = YES;
    self.directoryContentsView.allowsReordering = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageViewFrameChanged:) name:NSViewFrameDidChangeNotification object:self.imageView];
}

- (void)baseDirectoryChanged {
    if ( !self.window ) {
        NSLog(@"SSImageBrowserWindow: setting baseDirectoryURL before initialization complete");
        return;
    }
    if ( self.baseDirectoryURL ) {
        [self loadImageDirectoryTreeAsync];
        [self setWindowTitle];
    }
}

- (void)setBaseDirectoryURL:(NSURL *)baseDirectoryURL {
    if ( _baseDirectoryURL != baseDirectoryURL ) {
        _baseDirectoryURL = baseDirectoryURL;
        [self baseDirectoryChanged];
    }
}

+ (NSArray *)restorableStateKeyPaths {
    return @[ @"baseDirectoryURL" ];
}

#pragma mark private methods
- (void)setWindowTitle {
    NSArray *pathComponents = [[NSFileManager defaultManager] componentsToDisplayForPath:self.baseDirectoryURL.path];
    self.window.title = [pathComponents componentsJoinedByString:@"/"];
}

- (void)loadImageDirectoryTreeAsync {
    NSLog(@"loadImageDirectoryTreeAsync");
    [self.spinner startAnimation:self];
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
    NSLog(@"loadedDirectoryTree");
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
