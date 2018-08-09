//
//  SectionSeparatorView.swift
//  Taskbox
//
//  Created by Hamon Riazy on 15/05/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit

class SectionSeparatorView: UITableViewHeaderFooterView, Reusable {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.init(name: "AvenirNext-Regular", size: 14)
        label.textColor = #colorLiteral(red: 0.4431372549, green: 0.4431372549, blue: 0.4431372549, alpha: 1)
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10.0),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10.0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
