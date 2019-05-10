//
//  Localizable.swift
//  Worksheet
//
//  Created by Knut Arild Slåtsve on 17/02/2019.
//  Copyright © 2019 Knut Arild Slåtsve. All rights reserved.
//

import Foundation

/// A type with a localized string that will load the appropriate localized value for a shortcut.
protocol LocalizableShortcutString {
    
    /// - Returns: A string key for the localized value.
    var shortcutLocalizationKey: String { get }
}

/// A type with a localized currency string that is appropiate to display in UI.
protocol LocalizableCurrency {
    
    /// - Returns: A string that displays a locale sensitive currency format.
    var localizedCurrencyValue: String { get }
}
