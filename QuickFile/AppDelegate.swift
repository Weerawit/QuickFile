//
//  AppDelegate.swift
//  QuickFile
//
//  Created by Weerawit Maneepongsawat on 11/20/2557 BE.
//  Copyright (c) 2557 Weerawit Maneepongsawat. All rights reserved.
//

import Cocoa
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
       
        var foundSetting: Bool = false
        if (Process.arguments.count > 1) {
            for (index, arg) in enumerate(Process.arguments) {
                if arg == "setting" {
                    foundSetting = true
                    break
                }
            }
        }
        
        //
        if !foundSetting {
            if !handleLocalNotification(aNotification) {
                handleCommandLine()
            }

            NSApplication.sharedApplication().terminate(self)
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(theApplication: NSApplication) -> Bool {
        //terminate process after close setting window
        return true
    }
    
    func handleLocalNotification(aNotification: NSNotification) -> Bool {
        if let userInfo: Dictionary = aNotification.userInfo {
            if let value: NSUserNotification = userInfo[NSApplicationLaunchUserNotificationKey] as? NSUserNotification {
                
                var log = "handleLocalNotification"

                let newFilename = value.identifier!
                let userDefault = NSUserDefaults.standardUserDefaults()
                var defaultEditor = Constants.EDITOR
                if let editor: String = userDefault.valueForKey("editor") as? String {
                    defaultEditor = editor
                }
                
                log += " newFilename : \(newFilename), defaultEditor: \(defaultEditor) \n"
                
                let workspace = NSWorkspace.sharedWorkspace()
                switch defaultEditor.lowercaseString {
                case "textedit":
                    workspace.openFile(newFilename, withApplication: "TextEdit")
                case "textwrangler":
                    if !workspace.openFile(newFilename, withApplication: "TextWrangler") {
                        workspace.openFile(newFilename, withApplication: "TextEdit")
                    }
                case "textmate":
                    if !NSWorkspace.sharedWorkspace().openFile(newFilename, withApplication: "TextMate") {
                        workspace.openFile(newFilename, withApplication: "TextEdit")
                    }
                default:
                    NSWorkspace.sharedWorkspace().openFile(newFilename, withApplication: "TextEdit")
                }
                
                log.writeToFile("/tmp/quick.log", atomically: true, encoding: NSUTF8StringEncoding, error: nil)
                return true
            }
        }
        return false
    }
    
    func handleCommandLine() {
        //--start load default---
        let userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var defaultFilename = Constants.FILENAME
        var defaultExtension = Constants.FILE_EXTENSION
        var defaultAppendSequence = Constants.APPEND_SEQUENCE
        var defaultOpenInEditor = Constants.OPEN_IN_EDITOR
        var defaultEditor = Constants.EDITOR
        
        if let filename: String = userDefault.valueForKey("filename") as? String {
            defaultFilename = filename
        }
        if let filenameExtension: String = userDefault.valueForKey("filenameExtension") as? String {
            defaultExtension = filenameExtension
        }
        if let appendSequence: String = userDefault.valueForKey("appendSequence") as? String {
            defaultAppendSequence = appendSequence
        }
        if let openInEditor: String = userDefault.valueForKey("openInEditor") as? String {
            defaultOpenInEditor = openInEditor
        }
        if let editor: String = userDefault.valueForKey("editor") as? String {
            defaultEditor = editor
        }
        //--end load default ---
        
        //--get current path from Finder---
        let finderPath: FinderPath = FinderPath()
        if let currentPath = finderPath.getCurrentPath() {
            
            var newFilename = currentPath + "/" + defaultFilename
            if !defaultExtension.isEmpty {
                newFilename = newFilename + "." + defaultExtension
            }
            var isCreatedFile = false
            let fileManager = NSFileManager.defaultManager()
            if fileManager.isWritableFileAtPath(currentPath) {
                if defaultAppendSequence.lowercaseString == "true" {
                    var i = 1;
                    while fileManager.fileExistsAtPath(newFilename) {
                        newFilename = currentPath + "/" + defaultFilename + "_\(i++)"
                        if !defaultExtension.isEmpty {
                            newFilename = newFilename + "." + defaultExtension
                        }
                    }
                }
                if !fileManager.fileExistsAtPath(newFilename) {
                    println("writing newFilename : \(newFilename)")
                    isCreatedFile = fileManager.createFileAtPath(newFilename, contents: nil, attributes: nil)
                } else {
                    println("filename is exist \(newFilename), not create a file")
                }
            }
            
            //send notification
            if isCreatedFile {
                let userNotificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()
                
                //alert in User Notification
                let notification:NSUserNotification = NSUserNotification()
                notification.title = "Your file has been created"
                notification.informativeText = newFilename
                notification.identifier = newFilename
                notification.hasActionButton = false
                //            notification.contentImage = NSBundle.mainBundle().resourceURL
                
                userNotificationCenter.deliverNotification(notification)
                
            }
            
            //--open editor--
            if defaultOpenInEditor.lowercaseString == "true" {
                let workspace = NSWorkspace.sharedWorkspace()
                switch defaultEditor.lowercaseString {
                case "textedit":
                    workspace.openFile(newFilename, withApplication: "TextEdit")
                case "textwrangler":
                    if !workspace.openFile(newFilename, withApplication: "TextWrangler") {
                        workspace.openFile(newFilename, withApplication: "TextEdit")
                    }
                case "textmate":
                    if !NSWorkspace.sharedWorkspace().openFile(newFilename, withApplication: "TextMate") {
                        workspace.openFile(newFilename, withApplication: "TextEdit")
                    }
                default:
                    NSWorkspace.sharedWorkspace().openFile(newFilename, withApplication: "TextEdit")
                }
                
            }
        } else {
            println("this path is not support")
        }
    }
}

