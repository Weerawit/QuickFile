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
    
    var window: NSWindow!
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        print("applicationWillFinishLaunching")
        var foundSetting: Bool = false
        if NSEvent.modifierFlags() == NSEventModifierFlags.option {
            foundSetting = true
        }
        
        if !foundSetting {
            handleCommandLine()
            
            NSApplication.shared().terminate(self)
        } else {
            
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            let windowController = storyboard.instantiateController(withIdentifier: "WindowController") as! NSWindowController
            
            if let window = windowController.window {
                self.window = window
            }
            
        }
        
    }
    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("applicationDidFinish")
        self.window.makeKeyAndOrderFront(self.window)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ theApplication: NSApplication) -> Bool {
        //terminate process after close setting window
        return true
    }
    
    func handleLocalNotification(_ aNotification: Notification) -> Bool {
        if let userInfo: Dictionary = (aNotification as NSNotification).userInfo {
            if let value: NSUserNotification = userInfo[NSApplicationLaunchUserNotificationKey] as? NSUserNotification {
                
                var log = "handleLocalNotification"

                let newFilename = value.identifier!
                let userDefault = UserDefaults.standard
                var defaultEditor = Constants.EDITOR
                if let editor: String = userDefault.value(forKey: "editor") as? String {
                    defaultEditor = editor
                }
                
                log += " newFilename : \(newFilename), defaultEditor: \(defaultEditor) \n"
                
                let workspace = NSWorkspace.shared()
                switch defaultEditor.lowercased() {
                case "textedit":
                    workspace.openFile(newFilename, withApplication: "TextEdit")
                case "textwrangler":
                    if !workspace.openFile(newFilename, withApplication: "TextWrangler") {
                        workspace.openFile(newFilename, withApplication: "TextEdit")
                    }
                case "textmate":
                    if !NSWorkspace.shared().openFile(newFilename, withApplication: "TextMate") {
                        workspace.openFile(newFilename, withApplication: "TextEdit")
                    }
                default:
                    if !NSWorkspace.shared().openFile(newFilename, withApplication: defaultEditor) {
                        workspace.openFile(newFilename, withApplication: "TextEdit")
                    }
                }
                
                //log.writeToFile("/tmp/quick.log", atomically: true, encoding: String.Encoding.utf8)
                return true
            }
        }
        return false
    }
    
    func handleCommandLine() {
        //--start load default---
        let userDefault: UserDefaults = UserDefaults.standard
        var defaultFilename = Constants.FILENAME
        var defaultExtension = Constants.FILE_EXTENSION
        var defaultAppendSequence = Constants.APPEND_SEQUENCE
        var defaultOpenInEditor = Constants.OPEN_IN_EDITOR
        var defaultEditor = Constants.EDITOR
        
        if let filename: String = userDefault.value(forKey: "filename") as? String {
            defaultFilename = filename
        }
        if let filenameExtension: String = userDefault.value(forKey: "filenameExtension") as? String {
            defaultExtension = filenameExtension
        }
        if let appendSequence: String = userDefault.value(forKey: "appendSequence") as? String {
            defaultAppendSequence = appendSequence
        }
        if let openInEditor: String = userDefault.value(forKey: "openInEditor") as? String {
            defaultOpenInEditor = openInEditor
        }
        if let editor: String = userDefault.value(forKey: "editor") as? String {
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
            let fileManager = FileManager.default
            if fileManager.isWritableFile(atPath: currentPath) {
                if defaultAppendSequence.lowercased() == "true" {
                    let i = 1;
                    while fileManager.fileExists(atPath: newFilename) {
                        newFilename = currentPath + "/" + defaultFilename + "_\(i+1)"
                        if !defaultExtension.isEmpty {
                            newFilename = newFilename + "." + defaultExtension
                        }
                    }
                }
                if !fileManager.fileExists(atPath: newFilename) {
                    print("writing newFilename : \(newFilename)")
                    isCreatedFile = fileManager.createFile(atPath: newFilename, contents: nil, attributes: nil)
                } else {
                    print("filename is exist \(newFilename), not create a file")
                }
            }
            
            //send notification
            if isCreatedFile {
                let userNotificationCenter = NSUserNotificationCenter.default
                
                //alert in User Notification
                let notification:NSUserNotification = NSUserNotification()
                notification.title = "Your file has been created"
                notification.informativeText = newFilename
                notification.identifier = newFilename
                notification.hasActionButton = false
                //            notification.contentImage = NSBundle.mainBundle().resourceURL
                
                userNotificationCenter.deliver(notification)
                
            }
            
            //--open editor--
            if defaultOpenInEditor.lowercased() == "true" {
                let workspace = NSWorkspace.shared()
                switch defaultEditor.lowercased() {
                case "textedit":
                    workspace.openFile(newFilename, withApplication: "TextEdit")
                case "textwrangler":
                    if !workspace.openFile(newFilename, withApplication: "TextWrangler") {
                        workspace.openFile(newFilename, withApplication: "TextEdit")
                    }
                case "textmate":
                    if !NSWorkspace.shared().openFile(newFilename, withApplication: "TextMate") {
                        workspace.openFile(newFilename, withApplication: "TextEdit")
                    }
                default:
                    if !NSWorkspace.shared().openFile(newFilename, withApplication: defaultEditor) {
                        workspace.openFile(newFilename, withApplication: "TextEdit")
                    }
                }
                
            }
        } else {
            print("this path is not support")
        }
    }
}

