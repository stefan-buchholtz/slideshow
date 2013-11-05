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
#import "SSImageView.h"
#import "NSOutlineView+SelectionUtils.h"

#define IDX_ZOOM_TO_FIT         0
#define IDX_ZOOM_OUT            1
#define IDX_ZOOM_TO_ACTUAL_SIZE 2
#define IDX_ZOOM_IN             3

NSString *const TOOLBAR_ID = @"imageBrowserToolbar";
NSString *const TOOLBARITEM_BROWSER_THUMBNAIL_SIZE = @"imageBrowserThumbnailSizeSlider";
NSString *const TOOLBARITEM_START_SLIDESHOW = @"startSlideShow";
NSString *const TOOLBARITEM_PREVIEW_ZOOM = @"previewZoomButtonGroup";
NSString *const TOOLBARITEM_PROGRESS_INDICATOR = @"progressIndicator";

@interface SSImageBrowserWindow ()

- (void)baseDirectoryChanged;

- (void)setWindowTitle;

- (void)loadImageDirectoryTreeAsync;

- (SSDirectory*)loadImageDirectoryTree:(NSURL*)baseDirectory;

- (void)loadedDirectoryTree:(SSDirectory*)directory;

- (void)displayImageFile:(SSFile*)imageFile;

- (void)displayImageURL:(NSURL*)imageURL;

- (NSSet*)selectedImages;

- (void)selectDirectoryWithPath:(NSString*)path;

- (void)expandParentDirectories:(SSDirectory*)directory;

@end

@implementation SSImageBrowserWindow

- (id)init {
    self = [super initWithWindowNibName:@"SSImageBrowserWindow"];
    return self;
}

- (void)windowDidLoad {
    // NSLog(@"windowDidLoad");
    [super windowDidLoad];
    
    NSString *dummyImagePath = [[NSBundle mainBundle] pathForResource: @"dummyImg" ofType: @"png"];
    [self displayImageURL:[NSURL fileURLWithPath: dummyImagePath]];
}

- (void)awakeFromNib {
    // NSLog(@"awakeFromNib");
    
    self.thumbnailZoom = 0.5;
    
    self.window.restorable = YES;
    self.window.restorationClass = [SSWindowManager class];
    self.window.identifier = ID_IMAGE_BROWSER;

    self.directoryContentsView.cellsStyleMask = IKCellsStyleShadowed | IKCellsStyleTitled;
    self.directoryContentsView.allowsMultipleSelection = YES;
    self.directoryContentsView.allowsEmptySelection = YES;
    self.directoryContentsView.allowsReordering = NO;
    self.directoryContentsView.allowsDroppingOnItems = NO;
    
    self.imageView.backgroundColor = [NSColor whiteColor];
}

- (void)baseDirectoryChanged {
    if ( !self.window ) {
        // NSLog(@"SSImageBrowserWindow: setting baseDirectoryURL before initialization complete");
        return;
    }
    if ( self.baseDirectoryURL ) {
        [self loadImageDirectoryTreeAsync];
        [self setWindowTitle];
    }
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
    if ([theKey isEqualToString:@"treeViewSelectionPath"]) {
        return NO;
    } else {
        return [super automaticallyNotifiesObserversForKey:theKey];
    }
}

+ (NSArray *)restorableStateKeyPaths {
    return @[ @"baseDirectoryURL", @"thumbnailZoom", @"previewZoom", @"previewZoomedToFit", @"treeViewSelectionPath" ];
}

#pragma mark private methods
- (void)setWindowTitle {
    NSArray *pathComponents = [[NSFileManager defaultManager] componentsToDisplayForPath:self.baseDirectoryURL.path];
    self.window.title = [pathComponents componentsJoinedByString:@"/"];
}

- (void)loadImageDirectoryTreeAsync {
    // NSLog(@"loadImageDirectoryTreeAsync");
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
    loadDirectoryTreeOperation = nil;
    backgroundTaskQueue = nil;
    
    [self selectDirectoryWithPath:_treeViewSelectionPath];
    // NSLog(@"loadedDirectoryTree");
}

- (void)displayImageFile:(SSFile*)imageFile {
    [self displayImageURL:imageFile.url];
}

- (void)displayImageURL:(NSURL*)imageURL {
    self.imageView.imageURL = imageURL;
    [self.imageView scrollToBeginningOfDocument:self];
}

- (NSSet*)selectedImages {
    NSIndexSet *selectionIndexes = [_directoryContentsView selectionIndexes];
    if ( selectionIndexes.count == 0 ) {
        return nil;
    }
    
    NSMutableSet *imageFiles = [[NSMutableSet alloc] init];
    [selectionIndexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        SSFile *imageFile = [[_imageBrowserDataSource imageBrowser:_directoryContentsView itemAtIndex:index] file];
        if ( imageFile ) {
            [imageFiles addObject:imageFile];
        }
    }];
    return imageFiles;
}

- (void)selectDirectoryWithPath:(NSString*)path {
    if ( _baseDirectory && path ) {
        SSFileSystemItem *selectedItem = [_baseDirectory findSubItemWithPath:path];
        if ( [selectedItem isKindOfClass:[SSDirectory class]] ) {
            [self expandParentDirectories:(SSDirectory*)selectedItem];
            [_directoryTreeView selectItem:selectedItem];
        }
    }
}

- (void)expandParentDirectories:(SSDirectory*)directory {
    SSDirectory *parent = (SSDirectory*)directory.parent;
    if ( parent ) {
        [self expandParentDirectories:parent];
        [_directoryTreeView expandItem:parent];
    }
}


#pragma mark actions
- (IBAction)clickedZoomButton:(id)sender {
    NSInteger buttonIndex = [sender selectedSegment];
    switch (buttonIndex) {
        case IDX_ZOOM_TO_FIT:
            [self.imageView zoomToFit:self];
            break;
        case IDX_ZOOM_OUT:
            [self.imageView zoomOut:self];
            break;
        case IDX_ZOOM_TO_ACTUAL_SIZE:
            [self.imageView zoomToActualSize:self];
            break;
        case IDX_ZOOM_IN:
            [self.imageView zoomIn:self];
            break;
    }
}

- (IBAction)startSlideshow:(id)sender {
    NSSet *imageFiles = [self selectedImages];
    if ( !imageFiles || imageFiles.count == 0 ) {
        if ( selectedDirectory ) {
            imageFiles = [selectedDirectory allFiles];
        }
    }
    
    if ( imageFiles && imageFiles.count > 0 ) {
        [[SSWindowManager mainWindowManager] startSlideShowWithImageFiles:imageFiles orderByDirectory:YES];
    }
}

#pragma mark property getters and setters
- (void)setBaseDirectoryURL:(NSURL *)baseDirectoryURL {
    if ( _baseDirectoryURL != baseDirectoryURL ) {
        _baseDirectoryURL = baseDirectoryURL;
        [self baseDirectoryChanged];
    }
}

- (void)setThumbnailZoom:(float)thumbnailZoom {
    if ( _thumbnailZoom != thumbnailZoom ) {
        _thumbnailZoom = thumbnailZoom;
        self.thumbnailZoomSlider.floatValue = thumbnailZoom;
        self.directoryContentsView.zoomValue = thumbnailZoom;
    }
}

- (NSString*)treeViewSelectionPath {
    return _treeViewSelectionPath;
}

- (void)setTreeViewSelectionPath:(NSString*)treeViewSelectionPath {
    if ( _treeViewSelectionPath != treeViewSelectionPath ) {
        _treeViewSelectionPath = treeViewSelectionPath;
        [self willChangeValueForKey:@"treeViewSelectionPath"];
        [self selectDirectoryWithPath:treeViewSelectionPath];
        [self didChangeValueForKey:@"treeViewSelectionPath"];
    }
}

#pragma mark window delegate methods
// window delegate methods
- (void)windowWillClose:(NSNotification *)notification {
    [self.manager removeImageBrowser:self];
}

#pragma mark outline view delegate methods
// outline view delegate methods
- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    [self willChangeValueForKey:@"treeViewSelectionPath"];
    selectedDirectory = [self.directoryTreeView itemAtRow:[self.directoryTreeView selectedRow]];
    _treeViewSelectionPath = selectedDirectory.url.path;
    [self didChangeValueForKey:@"treeViewSelectionPath"];
    self.imageBrowserDataSource.directory = selectedDirectory;
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

#pragma mark toolbar delegate methods
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return [NSArray arrayWithObjects:TOOLBARITEM_BROWSER_THUMBNAIL_SIZE, TOOLBARITEM_PREVIEW_ZOOM, TOOLBARITEM_START_SLIDESHOW, NSToolbarFlexibleSpaceItemIdentifier, TOOLBARITEM_PROGRESS_INDICATOR, nil];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [NSArray arrayWithObjects:TOOLBARITEM_BROWSER_THUMBNAIL_SIZE, TOOLBARITEM_PREVIEW_ZOOM, TOOLBARITEM_START_SLIDESHOW, NSToolbarFlexibleSpaceItemIdentifier,TOOLBARITEM_PROGRESS_INDICATOR, nil];
}

@end
