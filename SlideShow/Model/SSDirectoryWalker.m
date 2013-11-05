//
//  SSDirectoryWalker.m
//  SlideShow
//
//  Created by Stefan Buchholtz on 26.10.13.
//  Copyright (c) 2013 Stefan Buchholtz. All rights reserved.
//

#import "SSDirectoryWalker.h"

#import "SSFile.h"
#import "SSDirectory.h"

@interface SSDirectoryWalker ()

- (void)walkDirectory:(SSDirectory*)directory;

- (void)processFile:(NSURL*)file inDirectory:(SSDirectory*)directory;

@end

@implementation SSDirectoryWalker

- (SSDirectory*)findImagesInDirectory:(NSURL*)directoryURL {
    if ( directoryURL == nil || ![directoryURL isFileURL] ) {
        NSLog(@"SSDirectoryWalker.findImagesInDirectory: %@ is not a valid directory", directoryURL);
        return nil;
    }
    
    SSDirectory *baseDirectory = [[SSDirectory alloc] initWithURL:directoryURL];
    
    urlProperties = [NSArray arrayWithObjects:NSURLNameKey, NSURLIsDirectoryKey, NSURLIsRegularFileKey, NSURLIsPackageKey, NSURLIsReadableKey, NSURLLocalizedNameKey, nil];
    [self walkDirectory:baseDirectory];
    
    if ( [baseDirectory hasItems] ) {
        return baseDirectory;
    } else {
        return nil;
    }
}

- (void)walkDirectory:(SSDirectory*)directory {
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:directory.url
                                                  includingPropertiesForKeys: urlProperties
                                                                     options: NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsPackageDescendants
                                                                       error:nil];
    for (NSURL *file in files) {
        [self processFile:file inDirectory:directory];
    }
}

- (void)processFile:(NSURL*)file inDirectory:(SSDirectory*)directory {
    NSNumber *isReadable;
    [file getResourceValue:&isReadable forKey:NSURLIsReadableKey error:nil];
    if ( !isReadable.boolValue ) {
        return;
    }
    
    NSNumber *isFile;
    [file getResourceValue:&isFile forKey:NSURLIsRegularFileKey error:nil];
    if ( isFile.boolValue ) {
        if ( [self.supportedFileChecker isSupportedFile:file] ) {
            [directory addFilesObject:[[SSFile alloc] initWithURL:file]];
        }
    } else {
        NSNumber *isDirectory;
        NSNumber *isPackage;
        [file getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        [file getResourceValue:&isPackage forKey:NSURLIsPackageKey error:nil];
        if ( isDirectory.boolValue && !isPackage.boolValue ) {
            SSDirectory *subDirectory = [[SSDirectory alloc] initWithURL:file];
            [directory addSubDirectoriesObject:subDirectory];
            [self walkDirectory:subDirectory];
        }
    }
}


@end
