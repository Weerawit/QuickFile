//
//  FinderPath.h
//  QuickFile
//
//  Created by Weerawit Maneepongsawat on 11/19/2557 BE.
//  Copyright (c) 2557 Weerawit Maneepongsawat. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifndef QuickFile_FinderPath_h
#define QuickFile_FinderPath_h

@interface FinderPath : NSObject {
    // Protected instance variables (not recommended)
}

- (NSString*) getCurrentPath;

- (NSDictionary*) getCurrentWindow;

- (NSDictionary*) getIconViewOptions;

@end

#endif
