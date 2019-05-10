//
//  ViewController.swift
//  Worksheet
//
//  Created by Knut Arild Slåtsve on 08/01/2019.
//  Copyright © 2019 Knut Arild Slåtsve. All rights reserved.
//

import UIKit
import CoreData
import Intents

class ViewController: UIViewController {

    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageBGView: UIView!
    @IBOutlet weak var weeklyLabel: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkInButton.applyRoundedBoarder()
        checkOutButton.applyRoundedBoarder()
        
        messageBGView.layer.cornerRadius = 8
        messageBGView.layer.borderWidth = 0.5
        messageBGView.layer.borderColor = UIColor.lightGray.cgColor
        
        messageLabel.text = getGreeting()
        evaluateButtons()

        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(_:)), name: NSNotification.Name("ReloadNotification"), object: nil)
        
        setupLabels()
    }

    
    @objc func reloadData(_ notification: Notification?) {
        messageLabel.text = getGreeting()
        evaluateButtons()
    }
    
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        var greeting = ""
        switch hour {
        case 00 ... 04:
            greeting = "God natt!"
        case 05 ... 12:
            greeting = "God morgen!"
        case 13 ... 17:
            greeting = "God formiddag!"
        case 18 ... 23:
            greeting = "God ettermiddag!"
        default:
            greeting = ""
        }
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "checkIns") != nil {
            greeting.append("\n\nDu har følgende innsjekk:\n")
            let checkInValues = defaults.array(forKey: "checkIns") as! [[String]]
            for value in checkInValues {
                let dateTimeArr = value[1].components(separatedBy: " ")
                greeting.append("kl \(dateTimeArr[1]) - \(value[0])\n")
            }
            let stringToReturn = greeting.dropLast()
            return String(stringToReturn)
        }
        
        return greeting
    }
    
    @IBAction func showHelp(_ sender: Any) {

    }
    
    func evaluateButtons() {
        var checkInValues = [[String]]()
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "checkIns") != nil {
            checkInValues = defaults.array(forKey: "checkIns") as! [[String]]
        }
        let numberOfCheckins = checkInValues.count
        
        checkInButton.isEnabled = numberOfCheckins != 4
        if (!checkInButton.isEnabled) {
            checkInButton.setTitleColor(UIColor.gray, for: .disabled)
        }
        checkOutButton.isEnabled = numberOfCheckins != 0
        if (!checkOutButton.isEnabled) {
            checkOutButton.setTitleColor(UIColor.gray, for: .disabled)
        }
    }
    
    @IBAction func checkInPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showCheckInVC", sender: self)
    }
    
    @IBAction func checkOutPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showCheckOutVC", sender: self)
    }
    
    func setupLabels() {
        let currentWeekNumber = Calendar.current.component(.weekOfYear, from: Date())
        var weeklyHours: TimeInterval = 0
        var totalHours: TimeInterval = 0
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
            
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: iCloudDocumentsURL!.path)
                
                for file in files {
                    if !file.hasPrefix(".") {
                        let data = try String(contentsOfFile: "\(iCloudDocumentsURL!.path)/\(file)", encoding: .utf8).components(separatedBy: .newlines)
                        for line in data {
                            if !line.isEmpty {
                                let regex = try! NSRegularExpression(pattern: "[^0-9]")
                                let firstEntry = line.components(separatedBy: ",").first!.lowercased()
                                let range = NSRange(location: 0, length: firstEntry.utf8.count)
                                if regex.firstMatch(in: firstEntry, options: [], range: range) != nil {
                                    // first entry is not a date
                                    continue
                                }
                                let columns = line.components(separatedBy: ",")
                                let checkIn = columns[2].components(separatedBy: ":")
                                let checkOut = columns[3].components(separatedBy: ":")
                                
                                let formatter = DateComponentsFormatter()
                                formatter.unitsStyle = .full
                                formatter.allowedUnits = [NSCalendar.Unit.hour, NSCalendar.Unit.minute]
                                
                                var checkInComponents = DateComponents()
                                checkInComponents.hour = Int(checkIn[0])
                                checkInComponents.minute = Int(checkIn[1])
                                let checkInDate = Calendar.current.date(from: checkInComponents)!
                                
                                var checkOutComponents = DateComponents()
                                checkOutComponents.hour = Int(checkOut[0])
                                checkOutComponents.minute = Int(checkOut[1])
                                let checkOutDate = Calendar.current.date(from: checkOutComponents)!
                                
                                let elapsedTime = checkOutDate.timeIntervalSince(checkInDate)
                                
                                if (file.contains("\(currentWeekNumber)")) {
                                    weeklyHours += elapsedTime
                                }
                                totalHours += elapsedTime
                            }
                        }
                    }
                }
                
                var ti = NSInteger(totalHours)
                var minutes = (ti/60) % 60
                var hours = (ti/3600)
                semesterLabel.text = "\(hours) timer og \(minutes) minutter"
                
                ti = NSInteger(weeklyHours)
                minutes = (ti/60) % 60
                hours = (ti/3600)
                weeklyLabel.text = "\(hours) timer og \(minutes) minutter"
                
            } catch let error {
                print("Error: \(error)")
            }
            
        }
    }
}

