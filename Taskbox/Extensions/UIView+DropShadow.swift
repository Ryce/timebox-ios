//
//  UIView+DropShadow.swift
//  Taskbox
//
//  Created by Hamon Riazy on 10/08/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit

struct Edge: OptionSet {
    let rawValue: Int
    
    static let top = Edge(rawValue: 1 << 0)
    static let left = Edge(rawValue: 1 << 1)
    static let right = Edge(rawValue: 1 << 2)
    static let bottom = Edge(rawValue: 1 << 3)
    
    static let all: Edge = [top, left, right, bottom]
}

extension UIView {
    
    func addDropShadow(height: CGFloat = 4.0, shadowRadius: CGFloat = 5.0) {
        layer.cornerRadius = 2
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: height)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = shadowRadius
    }
    
    func addBorder(at edges: Edge = .all) {
        if edges.contains(.top) {
            
        }
        if edges.contains(.left) {
            
        }
        if edges.contains(.right) {
            
        }
        if edges.contains(.bottom) {
            
        }
    }
    
}
