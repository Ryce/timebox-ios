//
//  SmallTaskBubbleView.swift
//  Taskbox
//
//  Created by Hamon Riazy on 14/05/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit

class SmallTasksBubbleView: UIView {
    
    var tasks: [Task] = [] {
        didSet {
            configureLayout()
        }
    }
    
    func configureLayout() {
        subviews.forEach({ $0.removeFromSuperview() })
        tasks.sorted { $0.time?.beginning ?? Date() < $1.time?.beginning ?? Date() }
            .map { SmallTaskBubbleView.init($0) }
            .forEach { addSubview($0) }
    }
    
}

class SmallTaskBubbleView: UIView {
    
    var task: Task
    
    init(_ task: Task) {
        self.task = task
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
