//
//  UIView+DropShadow.swift
//  Taskbox
//
//  Created by Hamon Riazy on 10/08/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit

extension UIView {
    
    func addDropShadow() {
        layer.cornerRadius = 2
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 4.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5.0
    }
    
}
