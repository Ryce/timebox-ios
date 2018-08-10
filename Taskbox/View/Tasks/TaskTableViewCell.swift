//
//  TaskTableViewCell.swift
//  Timebox
//
//  Created by Hamon Riazy on 08/05/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    
    var task: Task? {
        didSet {
            titleLabel.text = task?.title
            durationLabel.text = task?.durationDescription
        }
    }
    
}
