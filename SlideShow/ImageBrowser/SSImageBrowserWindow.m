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
#import "NSArray+Map.h"
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

- (void)displayBlankImage;

- (NSSet*)selectedImages;

- (NSSet*)imagesInSelectedDirectories;

- (void)selectDirectoriesWithPaths:(NSArray*)paths;

- (void)expandParentDirectories:(SSDirectory*)directory;

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)item;

- (BOOL)validateToolbarDisplayMenuItem:(id)item enabled:(BOOL*)outEnabled;

@end

@implementation SSImageBrowserWindow

- (id)init {
    self = [super initWithWindowNibName:@"SSImageBrowserWindow"];
    return self;
}

- (void)windowDidLoad {
    // NSLog(@"windowDidLoad");
    [super windowDidLoad];
    
    [self displayBlankImage];
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.sortOrderByDirectory = [defaults boolForKey:@"sortOrderByDirectory"];
    self.showImagesInSubDirectories = [defaults boolForKey:@"showImagesInSubDirectories"];
}

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)item {
    BOOL enabled;
    
    NSMenuItem *menuItem = [(id)item isKindOfClass:[NSMenuItem class]] ? (NSMenuItem*)item : nil;
    
    if ( [self isZoomItem:item] ) {
        return displayingImage;
    } else if ( [self validateToolbarDisplayMenuItem:item enabled:&enabled] ) {
        return enabled;
    } else if ( item.action == @selector(startSlideshow:) ) {
        return selectedDirectories != nil && selectedDirectories.count > 0;
    } else if ( item.action == @selector(toggleSortByFolder:) ) {
        if ( menuItem ) {
            [menuItem setState:self.sortOrderByDirectory ? NSOnState : NSOffState];
        }
        return YES;
    } else if ( item.action == @selector(toggleShowImagesInSubFolders:) ) {
        if ( menuItem ) {
            [menuItem setState:self.showImagesInSubDirectories ? NSOnState : NSOffState];
        }
        return YES;
    } else {
        return YES;
    }
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
    if ([theKey isEqualToString:@"treeViewSelectionPaths"]) {
        return NO;
    } else {
        return [super automaticallyNotifiesObserversForKey:theKey];
    }
}

+ (NSArray *)restorableStateKeyPaths {
    return @[ @"baseDirectoryURL", @"thumbnailZoom", @"previewZoom", @"previewZoomedToFit", @"treeViewSelectionPaths", @"showImagesInSubDirectories", @"sortOrderByDirectory" ];
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
    
    [self selectDirectoriesWithPaths:_treeViewSelectionPaths];
    // NSLog(@"loadedDirectoryTree");
}

- (void)displayBlankImage {
    NSString *dummyImagePath = [[NSBundle mainBundle] pathForResource: @"dummyImg" ofType: @"png"];
    [self displayImageURL:[NSURL fileURLWithPath: dummyImagePath]];
    displayingImage = NO;
}

- (void)displayImageFile:(SSFile*)imageFile {
    [self displayImageURL:imageFile.url];
    displayingImage = YES;
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
        SSImageBrowserItem *item = [_imageBrowserDataSource imageBrowser:_directoryContentsView itemAtIndex:index];
        if ( item && item.isImage ) {
            [imageFiles addObject:item.file];
        }
    }];
    return imageFiles;
}

- (NSSet*)imagesInSelectedDirectories {
    if ( selectedDirectories == nil || selectedDirectories.count == 0 ) {
        return nil;
    }
    
    NSMutableSet *imageFiles = [[NSMutableSet alloc] init];
    for ( SSDirectory *directory in selectedDirectories ) {
        [imageFiles unionSet:[directory allFiles]];
    }
    return imageFiles;
}

- (void)selectDirectoriesWithPaths:(NSArray*)paths {
    if ( _baseDirectory && paths && paths.count > 0 ) {
        NSArray *selectedItems = [paths mapObjectsUsingBlock:^id(id path, NSUInteger idx) {
            SSDirectory *selectedDirectory = [_baseDirectory findSubDirectoryWithPath:path];
            [self expandParentDirectories:selectedDirectory];
            return selectedDirectory;
        }];
        [_directoryTreeView selectItems: selectedItems];
    }
}

- (void)expandParentDirectories:(SSDirectory*)directory {
    SSDirectory *parent = (SSDirectory*)directory.parent;
    if ( parent ) {
        [self expandParentDirectories:parent];
        [_directoryTreeView expandItem:parent];
    }
}

- (BOOL)isZoomItem:(id <NSValidatedUserInterfaceItem>)item {
    return item.action == @selector(zoomIn:)
            || item.action == @selector(zoomOut:)
            || item.action == @selector(zoomToFit:)
            || item.action == @selector(zoomToActualSize:)
            || item.action == @selector(clickedZoomButton:);
}

- (BOOL)validateToolbarDisplayMenuItem:(id)item enabled:(BOOL*)outEnabled {
    SEL action = [item action];
    if ( [item isKindOfClass:[NSMenuItem class]] ) {
        if ( action == @selector(showToolbarIcons:) || action == @selector(showToolbarText:) || action == @selector(showToolbarIconsAndText:) ) {
            *outEnabled = YES;
            BOOL selected;
            switch (self.window.toolbar.displayMode) {
                case NSToolbarDisplayModeDefault:
                case NSToolbarDisplayModeIconAndLabel:
                    selected = action == @selector(showToolbarIconsAndText:);
                    break;
                    
                case NSToolbarDisplayModeIconOnly:
                    selected = action == @selector(showToolbarIcons:);
                    break;
                    
                case NSToolbarDisplayModeLabelOnly:
                    selected = action == @selector(showToolbarText:);
                    break;
                    
                default:
                    selected = NO;
            }
            [item setState:selected ? NSOnState : NSOffState];
            return YES;
        }
    }
    return NO;
}


#pragma mark actions
- (IBAction)clickedZoomButton:(id)sender {
    NSInteger buttonIndex = [sender selectedSegment];
    switch (buttonIndex) {
        case IDX_ZOOM_TO_FIT:
            [self zoomToFit:self];
            break;
        case IDX_ZOOM_OUT:
            [self zoomOut:self];
            break;
        case IDX_ZOOM_TO_ACTUAL_SIZE:
            [self zoomToActualSize:self];
            break;
        case IDX_ZOOM_IN:
            [self zoomIn:self];
            break;
    }
}

- (IBAction)startSlideshow:(id)sender {
    NSSet *imageFiles = [self selectedImages];
    if ( !imageFiles || imageFiles.count == 0 ) {
        imageFiles = [self imagesInSelectedDirectories];
    }
    
    if ( imageFiles && imageFiles.count > 0 ) {
        [[SSWindowManager mainWindowManager] startSlideShowWithImageFiles:imageFiles orderByDirectory:_sortOrderByDirectory];
    }
}

- (IBAction)zoomToFit:(id)sender {
    [_imageView zoomToFit:self];
}

- (IBAction)zoomToActualSize:(id)sender {
    [_imageView zoomToActualSize:self];
}

- (IBAction)zoomIn:(id)sender {
    [_imageView zoomIn:self];
}

- (IBAction)zoomOut:(id)sender {
    [_imageView zoomOut:self];
}

- (IBAction)showToolbarIcons:(id)sender {
    self.window.toolbar.displayMode = NSToolbarDisplayModeIconOnly;
}

- (IBAction)showToolbarText:(id)sender {
    self.window.toolbar.displayMode = NSToolbarDisplayModeLabelOnly;
}

- (IBAction)showToolbarIconsAndText:(id)sender {
    self.window.toolbar.displayMode = NSToolbarDisplayModeIconAndLabel;
}

- (IBAction)toggleSortByFolder:(id)sender {
    self.sortOrderByDirectory = !self.sortOrderByDirectory;
}

- (IBAction)toggleShowImagesInSubFolders:(id)sender {
    self.showImagesInSubDirectories = !self.showImagesInSubDirectories;
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

- (NSArray*)treeViewSelectionPaths {
    return _treeViewSelectionPaths;
}

- (void)setTreeViewSelectionPaths:(NSArray*)treeViewSelectionPaths {
    if ( _treeViewSelectionPaths != treeViewSelectionPaths ) {
        _treeViewSelectionPaths = treeViewSelectionPaths;
        [self willChangeValueForKey:@"treeViewSelectionPaths"];
        [self selectDirectoriesWithPaths:treeViewSelectionPaths];
        [self didChangeValueForKey:@"treeViewSelectionPaths"];
    }
}

- (void)setShowImagesInSubDirectories:(BOOL)showImagesInSubDirectories {
    if ( _showImagesInSubDirectories != showImagesInSubDirectories ) {
        _showImagesInSubDirectories = showImagesInSubDirectories;
        _imageBrowserDataSource.showImagesInSubDirectories = showImagesInSubDirectories;
        [[NSUserDefaults standardUserDefaults] setBool:showImagesInSubDirectories forKey:@"showImagesInSubDirectories"];
    }
}

- (void)setSortOrderByDirectory:(BOOL)sortOrderByDirectory {
    if ( _sortOrderByDirectory != sortOrderByDirectory ) {
        _sortOrderByDirectory = sortOrderByDirectory;
        _imageBrowserDataSource.sortOrderByDirectory = sortOrderByDirectory;
        [[NSUserDefaults standardUserDefaults] setBool:sortOrderByDirectory forKey:@"sortOrderByDirectory"];
    }
}

#pragma mark window delegate methods
// window delegate methods
- (void)windowWillClose:(NSNotification *)notification {
    if ( notification.object == self.window ) {
        [self.manager removeImageBrowser:self];
    }
}

#pragma mark outline view delegate methods
// outline view delegate methods
- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    [self willChangeValueForKey:@"treeViewSelectionPaths"];
    selectedDirectories = [_directoryTreeView selectedItems];
    _treeViewSelectionPaths = [selectedDirectories mapObjectsUsingBlock:^id(id directory, NSUInteger idx) {
        return [directory url].path;
    }];
    [self didChangeValueForKey:@"treeViewSelectionPaths"];
    self.imageBrowserDataSource.directories = selectedDirectories;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    return NO;
}

#pragma mark image browser delegate methods
- (void)imageBrowserSelectionDidChange:(IKImageBrowserView *)imageBrowser {
    BOOL imageSelected = NO;
    NSUInteger selectedIndex = [[imageBrowser selectionIndexes] firstIndex];
    if ( selectedIndex != NSNotFound ) {
        SSImageBrowserItem *selectedItem = [self.imageBrowserDataSource imageBrowser:imageBrowser itemAtIndex:selectedIndex];
        if ( selectedItem.isImage ) {
            [self displayImageFile:(SSFile*)selectedItem.file];
            imageSelected = YES;
        }
    }
    if ( !imageSelected ) {
        [self displayBlankImage];
    }
}

- (void)imageBrowser:(IKImageBrowserView *)imageBrowser cellWasDoubleClickedAtIndex:(NSUInteger)index {
    SSImageBrowserItem *clickedItem = [_imageBrowserDataSource imageBrowser:imageBrowser itemAtIndex:index];
    if ( clickedItem && !clickedItem.isImage ) {
        [self expandParentDirectories:(SSDirectory*)clickedItem.file];
        [_directoryTreeView selectItem:clickedItem.file];
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
