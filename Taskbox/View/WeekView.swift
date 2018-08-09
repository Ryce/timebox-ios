//
//  WeekView.swift
//  Taskbox
//
//  Created by Hamon Riazy on 05/08/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit

fileprivate var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE"
    return formatter
}()

class WeekView: UICollectionView {
    
}

class DayViewCell: UICollectionViewCell, Reusable {
    
    var day: Date? {
        didSet {
            guard let day = day else { return }
            dayOfMonthLabel.text = "\(day.component(Calendar.Component.day))"
            dayOfWeek.text = dateFormatter.string(from: day).uppercased()
        }
    }
    
    @IBOutlet var dayOfMonthLabel: UILabel!
    @IBOutlet var dayOfWeek: UILabel!
}
