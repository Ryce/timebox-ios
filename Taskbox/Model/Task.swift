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
