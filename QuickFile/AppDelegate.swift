//
//  AppDelegate.swift
//  QuickFile
//
//  Created by Weerawit Maneepongsawat on 11/20/2557 BE.
//  Copyright (c) 2557 Weerawit Maneepongsawat. All rights reserved.
//

import Cocoa

//@NSApplicationMain --remove due to custom main.swift
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(theApplication: NSApplication) -> Bool {
        //terminate process after close setting window
        return true
    }
}

