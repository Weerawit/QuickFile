//
//  FinderPath.m
//  QuickFile
//
//  Created by Weerawit Maneepongsawat on 11/19/2557 BE.
//  Copyright (c) 2557 Weerawit Maneepongsawat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FinderPath.h"
#import "Finder.h"

@implementation FinderPath {
}


- (NSString*) getCurrentPath {
    
    FinderApplication* finder = [SBApplication applicationWithBundleIdentifier:@"com.apple.Finder"];
    
    FinderItem *target = [(NSArray*)[[finder selection]get] firstObject];
    if (target == nil){
        target = [[[[finder FinderWindows] firstObject] target] get];
    }
    
    NSURL* url =[NSURL URLWithString:target.URL];
    NSError* error;
    NSData* bookmark = [NSURL bookmarkDataWithContentsOfURL:url error:nil];
    NSURL* fullUrl = [NSURL URLByResolvingBookmarkData:bookmark
                                               options:NSURLBookmarkResolutionWithoutUI
                                         relativeToURL:nil
                                   bookmarkDataIsStale:nil
                                                 error:&error];
    if(fullUrl != nil){
        url = fullUrl;
    }
    
    
    NSString* path = [[url path] stringByExpandingTildeInPath];
    
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    
    if(!isDir){
        path = [path stringByDeletingLastPathComponent];
    }
    
    return path;

    
    /**
    FinderApplication *finder = [SBApplication applicationWithBundleIdentifier:@"com.apple.Finder"];
    
    SBElementArray *windowArrays = [finder windows];
    
    NSDictionary *properties = [[windowArrays objectAtIndex:0] properties];
    NSString *key = @"target";
    FinderApplicationFile *target = [properties objectForKey:key];
    return [target URL];
     */
}


- (NSDictionary*) getCurrentWindow {
    FinderApplication *finder = [SBApplication applicationWithBundleIdentifier:@"com.apple.Finder"];
    
    SBElementArray *windowArrays = [finder windows];
    
    NSDictionary *properties = [[windowArrays objectAtIndex:0] properties];
    return properties;
}


- (NSDictionary*) getIconViewOptions {
    FinderApplication *finder = [SBApplication applicationWithBundleIdentifier:@"com.apple.Finder"];
    
    SBElementArray *windowArrays = [finder windows];
    
    NSDictionary *properties = [[windowArrays objectAtIndex:0] properties];
    NSString *key = @"iconViewOptions";
    FinderFinderWindow *target = [properties objectForKey:key];
    return target.properties;
}
@end