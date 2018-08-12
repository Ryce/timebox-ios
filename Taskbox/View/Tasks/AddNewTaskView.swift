//
//  AddNewTaskView.swift
//  Taskbox
//
//  Created by Hamon Riazy on 11/08/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit

class AddNewTaskView: UIView {
    
    @IBOutlet var underlineView: UIView!
    
    var slider: UISlider = {
        var slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 180
        slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        return slider
    }()
    
    var timeLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 18)
        return label
    }()
    
    @IBOutlet var taskTextField: UITextField!
    
    @IBOutlet var underlineBottomConstraint: NSLayoutConstraint!
    @IBOutlet var textFieldTopConstraint: NSLayoutConstraint!
    
//    var slider: Slider = {
//        let slider = Slider(frame: .zero)
//        slider.translatesAutoresizingMaskIntoConstraints = false
//        slider.attributedTextForFraction = { fraction in
//            let formatter = NumberFormatter()
//            formatter.maximumIntegerDigits = 3
//            formatter.maximumFractionDigits = 0
//            let string = formatter.string(from: (fraction * 500) as NSNumber) ?? ""
//            return NSAttributedString(string: string)
//        }
//        slider.setMinimumLabelAttributedText(NSAttributedString(string: "0"))
//        slider.setMaximumLabelAttributedText(NSAttributedString(string: "500"))
//        slider.fraction = 0.5
//        slider.shadowOffset = CGSize(width: 0, height: 10)
//        slider.shadowBlur = 5
//        slider.shadowColor = UIColor(white: 0, alpha: 0.1)
//        slider.contentViewColor = UIColor(red: 78/255.0, green: 77/255.0, blue: 224/255.0, alpha: 1)
//        slider.valueViewColor = .white
//        return slider
//    }()
    
    @objc func sliderValueChanged(sender: UISlider) {
        timeLabel.text = "\(sender.value) minutes"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(slider)
        addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: 10),
            timeLabel.leftAnchor.constraint(equalTo: underlineView.leftAnchor),
            timeLabel.rightAnchor.constraint(equalTo: underlineView.rightAnchor),
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            slider.leftAnchor.constraint(equalTo: underlineView.leftAnchor),
            slider.rightAnchor.constraint(equalTo: underlineView.rightAnchor),
            ])
    }
    
    func showInputStyle() {
        underlineBottomConstraint.isActive = false
        textFieldTopConstraint.isActive = true
        taskTextField.isHidden = false
        taskTextField.becomeFirstResponder()
    }
    
    func hideInputStyle() {
        taskTextField.isHidden = true
        underlineBottomConstraint.isActive = true
        textFieldTopConstraint.isActive = false
    }
    
}
