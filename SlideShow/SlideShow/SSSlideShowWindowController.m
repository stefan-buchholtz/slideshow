//
//  SSSlideShowWindowWindowController.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 02.11.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSSlideShowWindowController.h"

#import "SSWindowManager.h"
#import "SSImageView.h"

#import "NSArray+SortedArrayWithKey.h"
#import "SSFile.h"

#import "KeyCodes.h"

@interface SSSlideShowWindowController ()

- (NSArray*)sortImageList:(NSSet*)imageFiles orderByDirectory:(BOOL)orderByDirectory;

- (void)loadImage;

@end

@implementation SSSlideShowWindowController

- (id)initWithImageList:(NSSet *)imageFiles orderByDirectory:(BOOL)orderByDirectory {
    self = [super initWithWindowNibName:@"SSSlideShowWindowController"];
    if (self) {
        _orderByDirectory = orderByDirectory;
        _imageList = [self sortImageList:imageFiles orderByDirectory:orderByDirectory];
        imageCount = (int)_imageList.count;
    }
    return self;
}

#pragma mark overridden inherited methods
- (void)windowDidLoad {
    [super windowDidLoad];
    self.imageView.backgroundColor = [NSColor blackColor];

    _position = 0;
    [self.imageView zoomToFit:self];
    [self loadImage];
}

- (void)keyDown:(NSEvent *)theEvent {
    NSString *characters = [[theEvent characters] lowercaseString];
    if ( [characters isEqualToString:@"+"] ) {
        [self.imageView zoomIn:self];
    } else if ( [characters isEqualToString:@"-"] ) {
        [self.imageView zoomOut:self];
    } else if ( [characters isEqualToString:@"0"] ) {
        [self.imageView zoomToActualSize:self];
    } else if ( [characters isEqualToString:@"="] ) {
        [self.imageView zoomToFit:self];
    } else if ( [characters isEqualToString:@"q"] ) {
        [self.window close];
    } else {
        switch ([theEvent keyCode]) {
            case kVK_LeftArrow:
                [self back:self];
                break;
                
            case kVK_UpArrow:
                if ( [theEvent modifierFlags] & NSAlternateKeyMask ) {
                    [_imageView scrollToBeginningOfDocument:self];
                } else {
                    [_imageView scrollLineUp:self];
                }
                break;
                
            case kVK_DownArrow:
                if ( [theEvent modifierFlags] & NSAlternateKeyMask ) {
                    [_imageView scrollToEndOfDocument:self];
                } else {
                    [_imageView scrollLineDown:self];
                }
                break;
                
            case kVK_RightArrow:
            case kVK_Space:
                [self forward:self];
                break;
            
            case kVK_Home:
                [self first:self];
                break;
                
            case kVK_End:
                [self last:self];
                break;
                
            case kVK_Escape:
                [self.window close];
                break;
                
            default:
                [super keyDown:theEvent];
                break;
        }
    }
}

#pragma mark public methods
- (void)forward:(id)sender {
    self.position = self.position + 1;
}

- (void)back:(id)sender {
    self.position = self.position - 1;
}

- (void)first:(id)sender {
    self.position = 0;
}

- (void)last:(id)sender {
    self.position = imageCount - 1;
}

#pragma mark private methods
- (NSArray*)sortImageList:(NSSet*)imageFiles orderByDirectory:(BOOL)orderByDirectory {
    NSArray *imageList = [imageFiles allObjects];
    if ( orderByDirectory ) {
        imageList = [imageList sortedArrayWithKey:@"fullName" ascending:YES];
    } else {
        imageList = [imageList sortedArrayWithKey:@"name" ascending:YES];
    }
    
    return imageList;
}

- (void)loadImage {
    if ( _position >= 0 && _position < imageCount ) {
        SSFile *imageFile = [self.imageList objectAtIndex:_position];
        self.imageView.imageURL = imageFile.url;
    }
}

#pragma mark property getters / setters
- (void)setPosition:(int)position {
    if ( position < 0 ) {
        if ( _wrapAround ) {
            position = imageCount + (position % imageCount);
        } else {
            position = 0;
        }
    } else if ( position >= _imageList.count ) {
        if ( _wrapAround ) {
            position = position % imageCount;
        } else {
            position = imageCount - 1;
        }
    }
    
    if ( position != _position ) {
        _position = position;
        [self loadImage];
    }
}

#pragma mark window delegate methods
- (void)windowWillClose:(NSNotification *)notification {
    [self.manager endSlideShow:self];
}


@end
