//
//  checkInVC.swift
//  Worksheet
//
//  Created by Knut Arild Slåtsve on 11/01/2019.
//  Copyright © 2019 Knut Arild Slåtsve. All rights reserved.
//

import Foundation
import UIKit

class CheckInVC: UIViewController {
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var codingButton: UIButton!
    @IBOutlet weak var selfStudyButton: UIButton!
    @IBOutlet weak var administrativeButton: UIButton!
    @IBOutlet weak var meetingButton: UIButton!
    
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
        
        let blurView = UIVisualEffectView()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .light)
        view.addSubview(blurView)
        view.sendSubviewToBack(blurView)
        
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "checkIns") != nil {
            let checkInValues = defaults.array(forKey: "checkIns") as! [[String]]
            for value in checkInValues {
                switch value[0] {
                    case "Koding":
                        codingButton.isHidden = true
                        break
                    case "Selvstudie":
                        selfStudyButton.isHidden = true
                        break
                    case "Administrativt":
                        administrativeButton.isHidden = true
                        break
                    case "Møte":
                        meetingButton.isHidden = true
                        break
                    default:
                        break
                }
            }
        }
        
    }
    @IBAction func codingButtonClicked(_ sender: Any) {
        completeCheckin("Koding")
    }
    
    @IBAction func selfStudyButtonClicked(_ sender: Any) {
        completeCheckin("Selvstudie")
    }
    
    @IBAction func administrativeButtonClicked(_ sender: Any) {
        completeCheckin("Administrativt")
    }
    
    @IBAction func meetingButtonClicked(_ sender: Any) {
        completeCheckin("Møte")
    }
    
    func completeCheckin(_ type: String) {
        
        let defaults = UserDefaults.standard
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let dateTimeString = formatter.string(from: currentDateTime)
        
        var checkIns = [[String]]()
        
        if defaults.object(forKey: "checkIns") != nil {
            checkIns = defaults.array(forKey: "checkIns") as! [[String]]
        }
        var newCheckIn = [String]()
        newCheckIn.append(type)
        newCheckIn.append(dateTimeString)
        
        checkIns.append(newCheckIn)
        
        defaults.set(checkIns, forKey: "checkIns")
        
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadNotification"), object: nil)
        }
    }
    
    
}
