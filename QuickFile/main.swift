//
//  main.swift
//  QuickFile
//
//  Created by Weerawit Maneepongsawat on 11/20/2557 BE.
//  Copyright (c) 2557 Weerawit Maneepongsawat. All rights reserved.
//

import Foundation
import Cocoa
import AppKit

var foundSetting: Bool = false
if (Process.arguments.count > 1) {
    for arg in Process.arguments {
        if arg == "setting" {
            foundSetting = true
            NSApplicationMain(C_ARGC, C_ARGV)
            break
        }
    }
}

if !foundSetting {
    
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
    
    //--get current pat from Finder---
    
    let finderPath: FinderPath = FinderPath()
    if let currentPath = finderPath.getCurrentPath() {
        
        var newFilename = currentPath + "/" + defaultFilename
        if !defaultExtension.isEmpty {
            newFilename = newFilename + "." + defaultExtension
        }
        var isCreatedFile = false
        let fileManager = NSFileManager.defaultManager()
        if fileManager.isWritableFileAtPath(currentPath) {
            println("writable")
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