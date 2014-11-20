//
//  main.swift
//  QuickFile
//
//  Created by Weerawit Maneepongsawat on 11/20/2557 BE.
//  Copyright (c) 2557 Weerawit Maneepongsawat. All rights reserved.
//

import Foundation
import Cocoa

var foundSetting: Bool = false
if (Process.arguments.count > 1) {
    for arg in Process.arguments {
        switch arg {
        case "-setting":
            foundSetting = true
            NSApplicationMain(C_ARGC,  C_ARGV)
            break
        default:
            println("default")
        }
    }
}

if !foundSetting {
    let finderPath: FinderPath = FinderPath()
    if let currentPath = finderPath.getCurrentPath() {
        
        
        
        
        
        println("currentPaht = \(currentPath)")
        let filename = currentPath.stringByAppendingPathComponent("untitle.txt")
        println("target filename : \(filename)")
        let text = ""
        //let result = text.writeToFile("/Users/Weerawit/untitle.txt", atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        //println(result)
        
        
        
        if let currentPathURL: NSURL = NSURL(fileURLWithPath: currentPath) {
            println("currentPathURL := \(currentPathURL)")
            let fileManager = NSFileManager.defaultManager()
            if let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(currentPath) {
                while let file = enumerator.nextObject() as? String {
                    println("filename := \(file)")
                }
            }
        }
    }


}