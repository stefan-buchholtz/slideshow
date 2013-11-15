//
//  SSImageBrowserItem.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 28.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Quartz/Quartz.h>

#import "SSImageBrowserItem.h"

#import "SSDirectory.h"
#import "SSFile.h"

@implementation SSImageBrowserItem

- (id)initWithFile:(SSFileSystemItem*)file {
    if ( self = [super init] ) {
        self.file = file;
        _isImage = [file isKindOfClass:[SSFile class]];
    }
    return self;
}

- (NSString *)imageUID {
    return self.file.url.path;
}

- (NSString *) imageRepresentationType {
    return _isImage ? IKImageBrowserNSURLRepresentationType : IKImageBrowserNSImageRepresentationType;
    return IKImageBrowserNSImageRepresentationType;
}

- (id)imageRepresentation {
    return _isImage ? self.file.url : [[NSWorkspace sharedWorkspace] iconForFileType:(__bridge NSString*)kUTTypeDirectory];
    return _isImage ? [[NSImage alloc] initWithContentsOfURL:self.file.url] : [[NSWorkspace sharedWorkspace] iconForFileType:(__bridge NSString*)kUTTypeDirectory];
}

- (NSString *) imageTitle {
    return self.file.name;
}


@end
