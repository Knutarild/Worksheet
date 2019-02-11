//
//  CheckOutVC.swift
//  Worksheet
//
//  Created by Knut Arild Slåtsve on 12/01/2019.
//  Copyright © 2019 Knut Arild Slåtsve. All rights reserved.
//

import Foundation
import UIKit

class CheckOutVC: UIViewController, UITextViewDelegate {
    @IBOutlet var backGroundView: UIView!
    @IBOutlet weak var codingButton: UIButton!
    @IBOutlet weak var selfStudyButton: UIButton!
    @IBOutlet weak var administrativeButton: UIButton!
    @IBOutlet weak var meetingButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        
        backGroundView.layer.cornerRadius = 8
        
        codingButton.layer.borderWidth = 0.5
        codingButton.layer.borderColor = UIColor.lightGray.cgColor
        codingButton.layer.cornerRadius = 8
        codingButton.clipsToBounds = true
        
        selfStudyButton.layer.borderWidth = 0.5
        selfStudyButton.layer.borderColor = UIColor.lightGray.cgColor
        selfStudyButton.layer.cornerRadius = 8
        selfStudyButton.clipsToBounds = true
        
        administrativeButton.layer.borderWidth = 0.5
        administrativeButton.layer.borderColor = UIColor.lightGray.cgColor
        administrativeButton.layer.cornerRadius = 8
        administrativeButton.clipsToBounds = true
        
        meetingButton.layer.borderWidth = 0.5
        meetingButton.layer.borderColor = UIColor.lightGray.cgColor
        meetingButton.layer.cornerRadius = 8
        meetingButton.clipsToBounds = true
        
        doneButton.layer.borderWidth = 0.5
        doneButton.layer.borderColor = UIColor.lightGray.cgColor
        doneButton.layer.cornerRadius = 8
        doneButton.clipsToBounds = true
        
        let blurView = UIVisualEffectView()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .light)
        view.addSubview(blurView)
        view.sendSubviewToBack(blurView)
        
        descriptionTextView.delegate = self
        
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "checkIns") != nil {
            let checkInValues = defaults.array(forKey: "checkIns") as! [[String]]
            for value in checkInValues {
                switch value[0] {
                case "Koding":
                    codingButton.isHidden = false
                    break
                case "Selvstudie":
                    selfStudyButton.isHidden = false
                    break
                case "Administrativt":
                    administrativeButton.isHidden = false
                    break
                case "Møte":
                    meetingButton.isHidden = false
                    break
                default:
                    break
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        descriptionTextView.resignFirstResponder()
        return true
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 60
                print(keyboardSize.height)
                //self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func codingPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set("Koding", forKey: "selectedType")
        showDescriptionView()
    }
    
    @IBAction func selfStudyPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set("Selvstudie", forKey: "selectedType")
        showDescriptionView()
    }
    
    @IBAction func administrativeButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set("Administrativt", forKey: "selectedType")
        showDescriptionView()
    }
    
    @IBAction func meetingButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set("Møte", forKey: "selectedType")
        showDescriptionView()
    }
    
    @IBAction func doneEditing(_ sender: Any) {
        let defaults = UserDefaults.standard
        let type = defaults.value(forKey: "selectedType") as! String
        let description = descriptionTextView.text!
        //let descriptionFormatted = description.replacingOccurrences(of: "\n", with: "\r")
        performCheckout(type, description)
        
    }
    
    func showDescriptionView() {
        messageLabel.text = "Legg til beskrivelse"
        meetingButton.isHidden = true
        administrativeButton.isHidden = true
        selfStudyButton.isHidden = true
        codingButton.isHidden = true
        descriptionTextView.isHidden = false
        doneButton.isHidden = false
        descriptionTextView.becomeFirstResponder()
    }
    
    
    func performCheckout(_ type: String, _ description: String) {
        
        let defaults = UserDefaults.standard
        var checkInValues = defaults.array(forKey: "checkIns") as! [[String]]
        var index: Int?
        for entry in checkInValues {
            if entry[0] == type {
                index = checkInValues.firstIndex(of: entry)
            }
        }
 
        let checkOutValue = checkInValues[index!]
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let dateTimeString = formatter.string(from: currentDateTime)
        
        let checkInString = checkOutValue[1]
        let checkInArr = checkInString.components(separatedBy: " ")
        let checkInDate = formatter.date(from: checkInString)!
        let checkInDateString: String = checkInArr[0]
        let checkInTime: String = checkInArr[1]
        let dateTimeArr = dateTimeString.components(separatedBy: " ")
        let currentDateString: String = dateTimeArr[0]
        let currentTime: String = dateTimeArr[1]
        let weekNumber = Calendar.current.component(.weekOfYear, from: checkInDate)
        
        let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
        if  iCloudDocumentsURL != nil {
            
            //Create the Directory if it doesn't exist
            if (!FileManager.default.fileExists(atPath: iCloudDocumentsURL!.path, isDirectory: nil)) {
                do {
                    try FileManager.default.createDirectory(at: iCloudDocumentsURL!, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Could not create iCloud directory.")
                }
            }
            
            /*
             
             //// XML OPTION BELOW
            
            let fileName = "Timeliste uke \(weekNumber).xml"
            let path = iCloudDocumentsURL!.appendingPathComponent(fileName)
            
            if (!FileManager.default.fileExists(atPath: path.path)) {
                FileManager.default.createFile(atPath: path.path, contents: nil)
                let header = "<?xml version='1.0' encoding='UTF-8'?>\n<Root></Root>"
                try? header.write(to: path, atomically: true, encoding: .utf8)
            }
            let textToWrite: String = """
            
            <Entry>
                <Uke>\(weekNumber)</Uke>
                <Dato>\(checkInDateString)</Dato>
                <Innsjekk>\(checkInTime)</Innsjekk>
                <Utsjekk>\(currentTime)</Utsjekk>
                <Type>\(type)</Type>
                <Beskrivelse>\(description)</Beskrivelse>
            </Entry>
            </Root>
            """
            
            var offset: UInt64?
            
            if let fileHandleReader = FileHandle(forReadingAtPath: path.path) {
                defer {
                    fileHandleReader.closeFile()
                }
                if let str = String(data: fileHandleReader.readDataToEndOfFile(), encoding: .utf8) {
                    let endTag = "</Root>"
                    if let range = str.range(of: endTag) {
                        let intIndex = str.utf8.distance(from: str.utf8.startIndex, to: range.lowerBound)
                        let fileOffset = fileHandleReader.offsetInFile
                        offset = fileOffset - (fileOffset - UInt64(intIndex))
                    }
                }
            }
            
            if let fileHandle = try? FileHandle(forWritingTo: path) {
                defer {
                    fileHandle.closeFile()
                }
                fileHandle.seek(toFileOffset: offset!)
                fileHandle.write(textToWrite.data(using: .utf8)!)
            } else {
                print("Failed writing to file.")
            }
            
            checkInValues.remove(at: index!)
            if checkInValues.count == 0 {
                defaults.removeObject(forKey: "checkIns")
            } else {
                defaults.set(checkInValues, forKey: "checkIns")
            }
            defaults.synchronize()
            dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadNotification"), object: nil)
            }
            
        } else {
            print("iCloud is NOT working!")
        }
 
            /// END XML OPTION
            */
         
            let fileName = "Worksheet uke \(weekNumber).csv"
            let path = iCloudDocumentsURL!.appendingPathComponent(fileName)
            
            
            if (!FileManager.default.fileExists(atPath: path.path)) {
                print("File does not exist..")
                FileManager.default.createFile(atPath: path.path, contents: nil)
                let header = "Uke,Dato,Innsjekk,Utsjekk,Arbeidstype,Beskrivelse\n"
                try? header.write(to: path, atomically: true, encoding: .utf8)
                print("file created at \(path.path)")
            }
            
            let csvText = "\(weekNumber),\(checkInDateString),\(checkInTime),\(currentTime),\(type),\"\(description)\"\n"
            if let fileHandle = try? FileHandle(forWritingTo: path) {
                defer {
                    fileHandle.closeFile()
                }
                fileHandle.seekToEndOfFile()
                fileHandle.write(csvText.data(using: .utf8)!)
                print("Data written to file at: \(path.path)")
            } else {
                print("Failed writing to file.")
            }
            
            checkInValues.remove(at: index!)
            if checkInValues.count == 0 {
                defaults.removeObject(forKey: "checkIns")
            } else {
                defaults.set(checkInValues, forKey: "checkIns")
            }
            defaults.synchronize()
            dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadNotification"), object: nil)
            }
            
        } else {
            print("iCloud is NOT working!")
        }
    }
}
