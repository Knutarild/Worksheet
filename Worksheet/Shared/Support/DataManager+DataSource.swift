//
//  DataManager+DataSupport.swift
//  Worksheet
//
//  Created by Knut Arild Slåtsve on 17/02/2019.
//  Copyright © 2019 Knut Arild Slåtsve. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    /// - Tag: app_group
    private static let AppGroup = "group.com.knut.Worksheet.Shared"
    
    enum StorageKeys: String {
        case activityOptions
        case activityHistory
        case voiceShortcutHistory
    }
    
    static let dataSuite = { () -> UserDefaults in
        guard let dataSuite = UserDefaults(suiteName: AppGroup) else {
            fatalError("Could not load UserDefaults for app group \(AppGroup)")
        }
        
        return dataSuite
    }()
}
