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
    
    @IBOutlet var bubbleView: UIView! {
        didSet {
            bubbleView?.layer.cornerRadius = 8.0
            bubbleView?.clipsToBounds = true
        }
    }
    
    var task: Task? {
        didSet {
            titleLabel.text = task?.title
            durationLabel.text = task?.durationDescription
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.contentView.backgroundColor = selected ? #colorLiteral(red: 1, green: 0.856891741, blue: 0.856891741, alpha: 1) : .white
            }
        } else {
            contentView.backgroundColor = selected ? #colorLiteral(red: 1, green: 0.856891741, blue: 0.856891741, alpha: 1) : .white
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.contentView.backgroundColor = highlighted ? #colorLiteral(red: 1, green: 0.9405691964, blue: 0.9405691964, alpha: 1) : .white
            }
        } else {
            contentView.backgroundColor = highlighted ? #colorLiteral(red: 1, green: 0.9405691964, blue: 0.9405691964, alpha: 1) : .white
        }
    }
    
}
