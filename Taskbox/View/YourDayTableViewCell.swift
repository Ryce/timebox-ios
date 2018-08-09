//
//  YourDayTableViewCell.swift
//  Taskbox
//
//  Created by Hamon Riazy on 15/05/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit

class YourDayTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var task: Task? {
        didSet {
            if let beginning = task?.time?.beginning {
                dateLabel.text = simpleTimeFormatter.string(from: beginning)
            }
            descriptionLabel.text = task?.title
        }
    }
    
}
