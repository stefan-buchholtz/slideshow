//
//  SSImageBrowserDataSource.h
//  SlideShow
//
//  Created by Stefan Buchholtz on 28.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Quartz/Quartz.h>
#import <Foundation/Foundation.h>

@class SSDirectory;

@interface SSImageBrowserDataSource : NSObject {
    NSArray *imageItems;
}

@property (nonatomic, strong) NSArray   *directories;
@property (nonatomic, assign) BOOL      showImagesInSubDirectories;
@property (nonatomic, assign) BOOL      sortOrderByDirectory;

@property (weak) IBOutlet IKImageBrowserView *imageBrowser;

- (NSUInteger)numberOfItemsInImageBrowser:(IKImageBrowserView *)imageBrowser;

- (id)imageBrowser:(IKImageBrowserView *)imageBrowser itemAtIndex:(NSUInteger)index;

@end
