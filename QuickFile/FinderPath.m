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
    FinderApplication *finder = [SBApplication applicationWithBundleIdentifier:@"com.apple.Finder"];
    
    SBElementArray *windowArrays = [finder windows];
    
    NSDictionary *properties = [[windowArrays objectAtIndex:0] properties];
    NSString *key = @"target";
    FinderApplicationFile *target = [properties objectForKey:key];
    return [target URL];
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