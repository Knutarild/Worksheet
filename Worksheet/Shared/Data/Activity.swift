//
//  Activity.swift
//  Worksheet
//
//  Created by Knut Arild Slåtsve on 17/02/2019.
//  Copyright © 2019 Knut Arild Slåtsve. All rights reserved.
//

import Foundation

public struct Activity: Codable {
    
    public let date: String
    public let type: ActivityItem
    public let checkIn: String
    public let checkOut: String
    public let description: String
    public let identifier: UUID
    
    public init(date: String, checkIn: String, identifier: UUID = UUID() ,checkOut: String, type: ActivityItem, description: String) {
        self.date = date
        self.checkIn = checkIn
        self.identifier = identifier
        self.checkOut = checkOut
        self.type = type
        self.description = description
    }
}
