//
//  Task.swift
//  Timebox
//
//  Created by Hamon Riazy on 08/05/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit
import CoreData

extension Task {
    
    var durationDescription: String {
        guard let duration = time?.duration else { return "" }
        if duration.hour == 2 {
            return "2 hour task"
        }
        if duration.hour == 1 {
            return "1 hour task"
        }
        if duration.hour == 0, duration.minute == 30 {
            return "30 minute task"
        }
        return String(format: "%02d:%02d", time?.duration?.hour ?? 0, time?.duration?.minute ?? 0)
    }
    
    func doesIntersect(with task: Task) -> Bool {
        guard let lhs = time?.timePeriod, let rhs = task.time?.timePeriod else { return false }
        return lhs.intersects(with: rhs)
    }
    
    func makeDragPreview() -> UIDragPreview {
        let minute = time!.duration!.minute
        let hours = time!.duration!.hour
        let height = (hours * 60) + minute
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: height))
        view.backgroundColor = .backgroundGrey
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Avenir Next", size: 14.0)
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        let timeLabel = UILabel(frame: .zero)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont(name: "Avenir Next", size: 14.0)
        timeLabel.text = durationDescription
        timeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        view.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 4.0),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4.0),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 4.0),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: timeLabel.topAnchor, constant: -4.0),
            timeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4.0),
            timeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 4.0),
            timeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4.0),
            ])
        
        return UIDragPreview(view: view)
    }
    
}

extension Time {
    
    var timePeriod: TimePeriod? {
        guard let beginning = beginning, let end = end else { return nil }
        return TimePeriod(beginning: beginning, end: end)
    }
    
}

class TaskDragItem: UIDragItem {
    var task: Task?
}

private func randomColor() -> UIColor {
    let hue = CGFloat(drand48())
    let saturation = CGFloat(drand48()/2)
    let brightness = CGFloat(0.8 + drand48()/5)
    return UIColor.init(hue: hue, saturation: saturation, brightness: brightness, alpha: 0.3)
}
