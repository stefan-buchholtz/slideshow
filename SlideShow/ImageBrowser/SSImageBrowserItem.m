//
//  SSImageBrowserItem.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 28.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import <Quartz/Quartz.h>

#import "SSImageBrowserItem.h"

#import "SSFile.h"

@implementation SSImageBrowserItem

- (id)initWithFile:(SSFile*)file {
    if ( self = [super init] ) {
        self.file = file;
    }
    return self;
}

- (NSString *)imageUID {
    return self.file.url.path;
}

- (NSString *) imageRepresentationType {
    return IKImageBrowserNSURLRepresentationType;
}

- (id)imageRepresentation {
    return self.file.url;
}

- (NSString *) imageTitle {
    return self.file.name;
}


@end
