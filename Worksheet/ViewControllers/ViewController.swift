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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        checkInButton.layer.cornerRadius = 8
        checkInButton.layer.borderWidth = 0.5
        checkInButton.layer.borderColor = UIColor.white.cgColor
        
        checkOutButton.layer.cornerRadius = 8
        checkOutButton.layer.borderWidth = 0.5
        checkOutButton.layer.borderColor = UIColor.white.cgColor
        
        messageBGView.layer.cornerRadius = 8
        messageBGView.layer.borderWidth = 0.5
        messageBGView.layer.borderColor = UIColor.lightGray.cgColor
        
        messageLabel.text = getGreeting()
        evaluateButtons()

        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(_:)), name: NSNotification.Name("ReloadNotification"), object: nil)
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
}

