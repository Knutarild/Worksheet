//
//  SettingsVC.swift
//  Worksheet
//
//  Created by Knut Arild Slåtsve on 09/01/2019.
//  Copyright © 2019 Knut Arild Slåtsve. All rights reserved.
//

import Foundation
import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        deleteButton.layer.cornerRadius = 5
        deleteButton.clipsToBounds = true
        deleteButton.layer.borderWidth = 2
        deleteButton.layer.borderColor = UIColor.white.cgColor
        
        cancelButton.layer.cornerRadius = 5
        let blurView = UIVisualEffectView()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .light)
        view.addSubview(blurView)
        view.sendSubviewToBack(blurView)
    }
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadNotification"), object: nil)
        }
    }
    
    @IBAction func deleteWorksheet(_ sender: Any) {
        let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
        if  iCloudDocumentsURL != nil {
            
            do {
                let fileList = try FileManager.default.contentsOfDirectory(at: iCloudDocumentsURL!, includingPropertiesForKeys: nil)
                for s in fileList {
                    try FileManager.default.removeItem(at: s)
                }
                dismiss(animated: true) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadNotification"), object: nil)
                }
            } catch {
                print("Error while enumerating files \(iCloudDocumentsURL!.path): \(error.localizedDescription)")
            }
        } else {
            print("iCloud is NOT working!")
        }
    }
    

    
}
