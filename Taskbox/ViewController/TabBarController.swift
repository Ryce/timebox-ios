//
//  TabBarController.swift
//  Taskbox
//
//  Created by Hamon Riazy on 15/05/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    var mainPersistentStore: PersistentStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.items?.forEach({ (item) in
            item.imageInsets.top = 5
            item.imageInsets.bottom = -5
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let newTabBarHeight = defaultTabBarHeight + 8.0
        
        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        
        tabBar.frame = newFrame
    }
    
}
