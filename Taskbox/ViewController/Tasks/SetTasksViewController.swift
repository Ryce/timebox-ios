//
//  ViewController.swift
//  Timebox
//
//  Created by Hamon Riazy on 08/05/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit
import CoreData

class SetTasksViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView?.contentInset.top = 4.0
            tableView?.contentInset.bottom = 4.0
            tableView.dragInteractionEnabled = true
            tableView.dragDelegate = self
        }
    }
    
    @IBOutlet var addNewTaskView: UIView!
    
    var tasks: [Task] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewTaskView.addDropShadow()
        title = "all tasks"
        
        loadItems()
        
        registerForKeyboardNotifications()
    }
    
    deinit {
        removeKeyboardNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Check if today was planned and show the day view or let user create his tasks
    }
    
    func loadItems() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "time.beginning == null")
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    @IBAction func createNewItem() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AddNewTaskViewController") as! AddNewTaskViewController
        viewController.context = context
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        viewController.delegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("Error saving item with \(error)")
        }
        tableView.reloadData()
    }
    
}

extension SetTasksViewController {
    
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
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        UIViewPropertyAnimator.init(duration: duration, curve: curve) {
            
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

extension SetTasksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TaskTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.task = tasks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            tasks.remove(at: indexPath.row)
            context.delete(task)
            do {
                try context.save()
            } catch {
                print("Error deleting item")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

extension SetTasksViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let task = tasks[indexPath.row]
        let itemProvider = NSItemProvider(object: task.objectID.uriRepresentation() as NSURL)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = indexPath
        dragItem.previewProvider = {
            return task.makeDragPreview()
        }
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
        self.tabBarController?.selectedIndex = 0
    }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        guard let indexPath = session.items.first?.localObject as? IndexPath else { return }
        let task = tasks[indexPath.row]
        if task.time?.beginning != nil {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

extension SetTasksViewController: AddNewTaskViewControllerDelegate {
    
    func addNewTaskViewController(_ viewController: AddNewTaskViewController, didSaveTask task: Task) {
        tasks.append(task)
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func addNewTaskViewController(_ viewController: AddNewTaskViewController, didFailWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }
    
    func addNewTaskViewControllerDidCancel(_ viewController: AddNewTaskViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}
