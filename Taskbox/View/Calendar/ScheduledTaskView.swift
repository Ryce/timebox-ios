//
//  ScheduledTaskView.swift
//  Taskbox
//
//  Created by Hamon Riazy on 19/08/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit

class ScheduledTaskView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 14.0)
        label.numberOfLines = 0
        return label
    }()
    
    let scheduledLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 14.0)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    var task: Task?
    
    convenience init(task: Task) {
        self.init(frame: .zero)
        self.task = task
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    func setupView() {
        titleLabel.text = task?.title
        scheduledLabel.text = task?.durationDescription
        
        backgroundColor = .backgroundGrey
        
        addSubview(titleLabel)
        addSubview(scheduledLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4.0),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4.0),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 4.0),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: scheduledLabel.topAnchor, constant: -4.0),
            scheduledLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4.0),
            scheduledLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 4.0),
            scheduledLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.0),
            ])
    }
    
}
