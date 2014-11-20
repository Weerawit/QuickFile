//
//  ViewController.swift
//  QuickFile
//
//  Created by Weerawit Maneepongsawat on 11/20/2557 BE.
//  Copyright (c) 2557 Weerawit Maneepongsawat. All rights reserved.
//
import Foundation
import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var fileNameTxt: NSTextField!
    @IBOutlet weak var fileExtensionTxt: NSTextField!
    @IBOutlet weak var appendSeqChk: NSButton!
    @IBOutlet weak var openInEditorChk: NSButton!
    @IBOutlet weak var editorRadio: NSMatrix!
    
    let userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func restoreDefault(sender: AnyObject) {
        println("default press")
        
        userDefault.setValue("Untitle", forKey: "filename")
        
    }
}

