//
//  ViewController.swift
//  QuickFile
//
//  Created by Weerawit Maneepongsawat on 11/20/2557 BE.
//  Copyright (c) 2557 Weerawit Maneepongsawat. All rights reserved.
//
import Cocoa
import Foundation
import AppKit

class TextFieldDelegate : NSObject, NSTextFieldDelegate {
    
    override func controlTextDidEndEditing(_ obj: Notification) {

        let userDefault: UserDefaults = UserDefaults.standard
        if let textField: NSTextField = obj.object as? NSTextField {
            print("text change \(String(describing: textField.identifier))")
            if textField.identifier == "filename" {
                userDefault.setValue(textField.stringValue, forKey: "filename")
            } else if textField.identifier == "fileExtension" {
                userDefault.setValue(textField.stringValue, forKey: "filenameExtension")
            } else if textField.identifier == "editorOther" {
                userDefault.setValue(textField.stringValue, forKey: "editor")
            }
        }
    }
}

class ViewController: NSViewController {

    @IBOutlet weak var fileNameTxt: NSTextField!
    @IBOutlet weak var fileExtensionTxt: NSTextField!
    @IBOutlet weak var appendSeqChk: NSButton!
    @IBOutlet weak var openInEditorChk: NSButton!
    @IBOutlet weak var editorRadio: NSMatrix!
    @IBOutlet weak var editorOther: NSTextField!
    
    let userDefault: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayValueFromUserDefault()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func displayValueFromUserDefault() {
        if let filename: String = userDefault.value(forKey: "filename") as? String {
            fileNameTxt.stringValue = filename
        } else {
            userDefault.setValue(Constants.FILENAME, forKey: "filename")
            fileNameTxt.stringValue = Constants.FILENAME
        }
        
        if let filenameExtension: String = userDefault.value(forKey: "filenameExtension") as? String {
            fileExtensionTxt.stringValue = filenameExtension
        } else {
            userDefault.setValue(Constants.FILE_EXTENSION, forKey: "filenameExtension")
            fileExtensionTxt.stringValue = Constants.FILE_EXTENSION
        }
        
        if let appendSequence: String = userDefault.value(forKey: "appendSequence") as? String {
            if appendSequence.lowercased() == "true" {
                appendSeqChk.state = NSOnState
            } else {
                appendSeqChk.state = NSOffState
            }
        } else {
            userDefault.setValue(Constants.APPEND_SEQUENCE, forKey: "appendSequence")
            appendSeqChk.state = NSOnState
        }
        
        if let openInEditor: String = userDefault.value(forKey: "openInEditor") as? String {
            if openInEditor.lowercased() == "true" {
                openInEditorChk.state = NSOnState
            } else {
                openInEditorChk.state = NSOffState
            }
        } else {
            userDefault.setValue(Constants.OPEN_IN_EDITOR, forKey: "openInEditor")
            openInEditorChk.state = NSOnState
        }
        
        if let editor: String = userDefault.value(forKey: "editor") as? String {
            switch editor.lowercased() {
            case "textmate":
                editorOther.isEnabled = false
                editorRadio.selectCell(atRow: 2, column: 0)
            case "textwrangler":
                editorOther.isEnabled = false
                editorRadio.selectCell(atRow: 1, column: 0)
            case "textedit":
                editorOther.isEnabled = false
                editorRadio.selectCell(atRow: 0, column: 0)
            default:
                editorRadio.selectCell(atRow: 3, column: 0)
                editorOther.isEnabled = true
                editorOther.stringValue = editor
            }
        } else {
            userDefault.setValue(Constants.EDITOR, forKey: "editor")
            editorRadio.selectCell(atRow: 0, column: 0)
        }

    }
    

    @IBAction func editorPress(_ sender: NSMatrix) {
        print("editorPress")
        switch editorRadio.selectedRow {
        case 2:
            editorOther.isEnabled = false
            userDefault.setValue("textmate", forKey: "editor")
        case 1:
            editorOther.isEnabled = false
            userDefault.setValue("textwrangler", forKey: "editor")
        case 3:
            editorOther.isEnabled = true
        default:
            editorOther.isEnabled = false
            userDefault.setValue("textedit", forKey: "editor")
        }
    }
    @IBAction func openInEditorPress(_ sender: NSButton) {
        print("openInEditorPress")
        if sender.state == NSOnState {
            userDefault.setValue("true", forKey: "openInEditor")
        } else {
            userDefault.setValue("false", forKey: "openInEditor")
        }
    }
    @IBAction func appendSequencePress(_ sender: NSButton) {
        print("appendSequencePress")
        if sender.state == NSOnState {
            userDefault.setValue("true", forKey: "appendSequence")
        } else {
            userDefault.setValue("false", forKey: "appendSequence")
        }
    }
    @IBAction func restoreDefault(_ sender: AnyObject) {
        print("default press")
        userDefault.setValue(Constants.FILENAME, forKey: "filename")
        userDefault.setValue(Constants.FILE_EXTENSION, forKey: "filenameExtension")
        userDefault.setValue(Constants.APPEND_SEQUENCE, forKey: "appendSequence")
        userDefault.setValue(Constants.OPEN_IN_EDITOR, forKey: "openInEditor")
        userDefault.setValue(Constants.EDITOR, forKey: "editor")
        displayValueFromUserDefault()
 
    }
    
}

