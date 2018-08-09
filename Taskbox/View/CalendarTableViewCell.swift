//
//  CalendarTableViewCell.swift
//  Taskbox
//
//  Created by Hamon Riazy on 10/05/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var tasksContentView: UIView!
    
    var bubbleViews: [MicroBubbleTaskView] = []
    
    var tasks: [Task] = [] {
        didSet {
            clearPreviousSetup()
            setDate()
            setupConstraints()
        }
    }
    
    func clearPreviousSetup() {
        bubbleViews.forEach({ $0.removeFromSuperview() })
        bubbleViews.removeAll()
    }
    
    func setDate() {
        guard tasks.count > 0 else { return }
        
        if let beginning = tasks.first?.time?.beginning {
            let weekdayString = weekdayFormatter.string(from: beginning)
            let dateString = simpleDateFormatter.string(from: beginning)
            let combinedString = """
            \(weekdayString)
            \(dateString)
            """
            dateLabel.text = combinedString
        }
    }
    
    func setupConstraints() {
        guard tasks.count > 0 else { return }
        
        var allConstraints: [NSLayoutConstraint] = []
        
        let firstBubble = MicroBubbleTaskView.create()
        
        firstBubble.titleLabel.text = tasks.first?.title
        
        tasksContentView.addSubview(firstBubble)
        
        allConstraints.append(firstBubble.topAnchor.constraint(equalTo: tasksContentView.topAnchor))
        allConstraints.append(firstBubble.leftAnchor.constraint(equalTo: tasksContentView.leftAnchor))
        allConstraints.append(firstBubble.rightAnchor.constraint(equalTo: tasksContentView.rightAnchor))
        
        var previous: MicroBubbleTaskView! = firstBubble
        
        for task in tasks.dropFirst() {
            let bubble = MicroBubbleTaskView.create()
            bubble.titleLabel.text = task.title
            
            tasksContentView.addSubview(bubble)
            
            allConstraints.append(bubble.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 3.0))
            allConstraints.append(bubble.leftAnchor.constraint(equalTo: previous.leftAnchor))
            allConstraints.append(bubble.rightAnchor.constraint(equalTo: previous.rightAnchor))
            bubbleViews.append(bubble)
            previous = bubble
        }
        
        if tasks.count > 1 {
            allConstraints.append(previous.bottomAnchor.constraint(equalTo: tasksContentView.bottomAnchor))
        }
        
        NSLayoutConstraint.activate(allConstraints)
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

class MicroBubbleTaskView: UIView {
    
    var titleLabel: UILabel!
    
    static func create() -> MicroBubbleTaskView {
        let view = MicroBubbleTaskView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.init(name: "AvenirNext-DemiBold", size: 14)
        label.textColor = #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
        
        view.titleLabel = label
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 24.0),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 9.0),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 14.0),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
            ])
        
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        
        return view
    }
    
}
