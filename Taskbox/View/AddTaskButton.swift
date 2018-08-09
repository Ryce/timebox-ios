//
//  AddTaskButton.swift
//  Taskbox
//
//  Created by Hamon Riazy on 10/06/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit

class AddTaskButton: UIButton {
    
    convenience init() {
        self.init(type: .custom)
        
        heightAnchor.constraint(equalToConstant: 44)
        widthAnchor.constraint(equalToConstant: 120)
        
        layer.cornerRadius = 22
        clipsToBounds = true
        
        backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.4588235294, blue: 0.2666666667, alpha: 1)
        setTitleColor(.white, for: .normal)
    }
    
}
