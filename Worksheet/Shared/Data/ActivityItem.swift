//
//  ActivityItem.swift
//  Worksheet
//
//  Created by Knut Arild Slåtsve on 17/02/2019.
//  Copyright © 2019 Knut Arild Slåtsve. All rights reserved.
//

import Foundation

public struct ActivityItem: Codable, Hashable {
    
    public let itemName: String
    public let shortcutNameKey: String
    public var isCheckedIn: Bool
    
    public init(itemName: String, shortcutNameKey: String, isCheckedIn: Bool) {
        self.itemName = itemName
        self.shortcutNameKey = shortcutNameKey
        self.isCheckedIn = isCheckedIn
    }
}


extension ActivityItem: LocalizableShortcutString {
    
    var shortcutLocalizationKey: String {
        return shortcutNameKey
    }
}
