//
//  ViewController.swift
//  QuickFile
//
//  Created by Weerawit Maneepongsawat on 11/20/2557 BE.
//  Copyright (c) 2557 Weerawit Maneepongsawat. All rights reserved.
//
import Cocoa
import Foundation

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
        displayValueFromUserDefault()
        

    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func displayValueFromUserDefault() {
        if let filename: String = userDefault.valueForKey("filename") as? String {
            fileNameTxt.stringValue = filename
        } else {
            userDefault.setValue(Constants.FILENAME, forKey: "filename")
            fileNameTxt.stringValue = Constants.FILENAME
        }
        
        if let filenameExtension: String = userDefault.valueForKey("filenameExtension") as? String {
            fileExtensionTxt.stringValue = filenameExtension
        } else {
            userDefault.setValue(Constants.FILE_EXTENSION, forKey: "filenameExtension")
            fileExtensionTxt.stringValue = Constants.FILE_EXTENSION
        }
        
        if let appendSequence: String = userDefault.valueForKey("appendSequence") as? String {
            if appendSequence.lowercaseString == "true" {
                appendSeqChk.state = NSOnState
            } else {
                appendSeqChk.state = NSOffState
            }
        } else {
            userDefault.setValue(Constants.APPEND_SEQUENCE, forKey: "appendSequence")
            appendSeqChk.state = NSOnState
        }
        
        if let openInEditor: String = userDefault.valueForKey("openInEditor") as? String {
            if openInEditor.lowercaseString == "true" {
                openInEditorChk.state = NSOnState
            } else {
                openInEditorChk.state = NSOffState
            }
        } else {
            userDefault.setValue(Constants.OPEN_IN_EDITOR, forKey: "openInEditor")
            openInEditorChk.state = NSOnState
        }
        
        if let editor: String = userDefault.valueForKey("editor") as? String {
            switch editor.lowercaseString {
            case "textmate":
                editorRadio.selectCellAtRow(2, column: 0)
            case "textwrangler":
                editorRadio.selectCellAtRow(1, column: 0)
            default:
                editorRadio.selectCellAtRow(0, column: 0)
            }
        } else {
            userDefault.setValue(Constants.EDITOR, forKey: "editor")
            editorRadio.selectCellAtRow(0, column: 0)
        }

    }

    @IBAction func extensionChange(sender: NSTextField) {
        println("extensionChange")
        userDefault.setValue(fileExtensionTxt.stringValue, forKey: "filenameExtension")
    }
    @IBAction func filenameChange(sender: NSTextField) {
        println("filenameChange")
        userDefault.setValue(fileNameTxt.stringValue, forKey: "filename")
    }

    @IBAction func editorPress(sender: NSMatrix) {
        println("editorPress")
        switch editorRadio.selectedRow {
        case 2:
            userDefault.setValue("textmate", forKey: "editor")
        case 1:
            userDefault.setValue("textwrangler", forKey: "editor")
        default:
            userDefault.setValue("textedit", forKey: "editor")
        }
    }
    @IBAction func openInEditorPress(sender: NSButton) {
        println("openInEditorPress")
        if sender.state == NSOnState {
            userDefault.setValue("true", forKey: "openInEditor")
        } else {
            userDefault.setValue("false", forKey: "openInEditor")
        }
    }
    @IBAction func appendSequencePress(sender: NSButton) {
        println("appendSequencePress")
        if sender.state == NSOnState {
            userDefault.setValue("true", forKey: "appendSequence")
        } else {
            userDefault.setValue("false", forKey: "appendSequence")
        }
    }
    @IBAction func restoreDefault(sender: AnyObject) {
        println("default press")
        userDefault.setValue(Constants.FILENAME, forKey: "filename")
        userDefault.setValue(Constants.FILE_EXTENSION, forKey: "filenameExtension")
        userDefault.setValue(Constants.APPEND_SEQUENCE, forKey: "appendSequence")
        userDefault.setValue(Constants.OPEN_IN_EDITOR, forKey: "openInEditor")
        userDefault.setValue(Constants.EDITOR, forKey: "editor")
        displayValueFromUserDefault()
 
    }
    
}

