//
//  AddNewTaskView.swift
//  Taskbox
//
//  Created by Hamon Riazy on 11/08/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit
import CoreData

protocol AddNewTaskViewControllerDelegate: class {
    func addNewTaskViewController(_ viewController: AddNewTaskViewController, didSaveTask task: Task)
    func addNewTaskViewController(_ viewController: AddNewTaskViewController, didFailWithError error: Error)
    func addNewTaskViewControllerDidCancel(_ viewController: AddNewTaskViewController)
}

class AddNewTaskViewController: UIViewController {
    
    @IBOutlet var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 8.0
        }
    }
    
    @IBOutlet var taskTextField: UITextField!
    @IBOutlet var slider: UISlider!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    
    var context: NSManagedObjectContext?
    weak var delegate: AddNewTaskViewControllerDelegate?
    
    @IBOutlet var containerBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancel)))
    }
    
    deinit {
        removeKeyboardNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskTextField.becomeFirstResponder()
    }
    
    @IBOutlet var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 4
        }
    }
    
    @IBAction func updateTime(sender: UISlider) {
        timeLabel.text = "\(Int(slider.value)) minutes"
    }
    
    @IBAction func save() {
        guard let context = context else { fatalError("Context was not set for add task view controller") }
        let newTask = Task(context: context)
        let newTime = Time(context: context)
        
        newTime.duration = Date.from(minutes: Int(slider.value))
        newTask.title = taskTextField.text
        newTask.time = newTime
        
        do {
            try context.save()
            delegate?.addNewTaskViewController(self, didSaveTask: newTask)
        } catch let error {
            delegate?.addNewTaskViewController(self, didFailWithError: error)
        }
    }
    
    @IBAction func cancel() {
        self.delegate?.addNewTaskViewControllerDidCancel(self)
    }
    
}

extension AddNewTaskViewController {
    
    func removeKeyboardNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowEvent(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHideEvent(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShowEvent(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        let curve = UIView.AnimationCurve(rawValue: (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!
        let duration = TimeInterval(truncating: userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber)
        
        guard let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        UIViewPropertyAnimator.init(duration: duration, curve: curve) {
            self.containerBottomConstraint.constant = endFrame.height + 20
            }.startAnimation()
    }
    
    @objc func keyboardHideEvent(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        let curve = UIView.AnimationCurve(rawValue: (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!
        let duration = TimeInterval(truncating: userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber)
        
        UIViewPropertyAnimator.init(duration: duration, curve: curve) {
            
            }.startAnimation()
    }
    
}
