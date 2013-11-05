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

- (id)initWithImageList:(NSSet *)imageFiles orderByDirectory:(BOOL)orderByDirectory;

- (void)forward:(id)sender;

- (void)back:(id)sender;

- (void)first:(id)sender;

- (void)last:(id)sender;

@end
