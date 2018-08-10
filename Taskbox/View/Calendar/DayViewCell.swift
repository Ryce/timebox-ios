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

class DayViewCell: UICollectionViewCell, Reusable {
    
    var day: Date? {
        didSet {
            guard let day = day else { return }
            dayOfMonthLabel.text = "\(day.component(Calendar.Component.day))"
            dayOfWeek.text = dateFormatter.string(from: day).uppercased()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            dayOfMonthLabel.textColor = isSelected ? UIColor.darkText : UIColor.greyText
            dayOfWeek.textColor = isSelected ? UIColor.darkText : UIColor.greyText
        }
    }
    
    @IBOutlet var dayOfMonthLabel: UILabel!
    @IBOutlet var dayOfWeek: UILabel!
}
