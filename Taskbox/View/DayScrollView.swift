//
//  DayScrollView.swift
//  Taskbox
//
//  Created by Hamon Riazy on 21/07/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit
import CoreImage
import ImageIO

class DayScrollView: UIScrollView {
    
    @IBOutlet var hoursStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        (0...24).forEach({ hoursStackView.addArrangedSubview(HourView(hour: $0)) })
    }
    
}

class HourView: UIView {
    
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "haa"
        return formatter
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7333333333, alpha: 1)
        label.font = UIFont(name: "Avenir Next", size: 30.0)
        return label
    }()
    
    convenience init(hour: Int) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        var components = DateComponents(calendar: .current, timeZone: nil, era: 0, year: 0, month: 0, day: 0, hour: hour, minute: 0, second: 0, nanosecond: 0, weekday: 0, weekdayOrdinal: 0, quarter: 0, weekOfMonth: 0, weekOfYear: 0, yearForWeekOfYear: 0)
        components.hour = hour
        guard let date = components.date else { return }
        timeLabel.text = HourView.dateFormatter.string(from: date)
        heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor),
            timeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0)
            ])
    }
    
}
