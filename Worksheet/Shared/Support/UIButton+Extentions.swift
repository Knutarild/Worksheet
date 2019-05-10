//
//  UIButton+Extentions.swift
//  Worksheet
//
//  Created by Knut Arild Slåtsve on 18/02/2019.
//  Copyright © 2019 Knut Arild Slåtsve. All rights reserved.
//

import UIKit

extension UIButton {
    public func applyRoundedBoarder() {
        layer.cornerRadius = 8
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.white.cgColor
    }
}
