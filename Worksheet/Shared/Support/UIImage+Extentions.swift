//
//  UIImage+Extentions.swift
//  Worksheet
//
//  Created by Knut Arild Slåtsve on 18/02/2019.
//  Copyright © 2019 Knut Arild Slåtsve. All rights reserved.
//

import UIKit

extension UIImageView {
    public func applyRoundedCorners() {
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
