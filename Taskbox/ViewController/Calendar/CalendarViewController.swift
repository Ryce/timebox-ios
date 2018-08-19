//
//  CalendarViewController.swift
//  Taskbox
//
//  Created by Hamon Riazy on 10/05/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData

class CalendarViewController: UIViewController {
    
    let monthOnlyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    private let capacity = 1000000
    
    @IBOutlet var dayScrollView: DayScrollView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var monthLabel: UILabel!
    
    @IBOutlet var schedulingLabel: UILabel!
    
    @IBOutlet var schedulingLabelTopConstraint: NSLayoutConstraint!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.addDropShadow()
        dayScrollView.addInteraction(UIDropInteraction(delegate: self))
        
        let tasks = loadItems(for: Date())
        dayScrollView.setNewTasks(tasks.map({ taskView(for: $0) }))
        
        let indexPath = IndexPath(row: capacity / 2, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCurrentMonthIfNeeded()
    }
    
    private func updateCurrentMonthIfNeeded() {
        guard let cells = collectionView.visibleCells as? [DayViewCell], !cells.isEmpty else { return }
        let months = cells.compactMap({ $0.day?.component(.month) })
        let counts = months.reduce(into: [:]) { $0[$1, default: 0] += 1 }
        var highest = (0, 0)
        counts.forEach { (key, value) in
            if value >= highest.1 {
                highest = (key, value)
            }
        }
        let components = DateComponents(calendar: .current, timeZone: nil, era: nil, year: nil, month: highest.0, day: nil, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        guard let date = components.date else { return }
        let newMonth = monthOnlyDateFormatter.string(from: date)
        animateMonthChange(with: newMonth)
    }
    
    func animateMonthChange(with newMonth: String) {
        if monthLabel.text != newMonth {
            UIView.animate(withDuration: 0.2, animations: {
                self.monthLabel.alpha = 0.0
            }) { (didFinish) in
                self.monthLabel.text = newMonth
                UIView.animate(withDuration: 0.2, animations: {
                    self.monthLabel.alpha = 1.0
                })
            }
        }
    }
    
    func loadItems(for date: Date) -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = date.predicate()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        return []
    }
    
    func date(for indexPath: IndexPath) -> Date? {
        let dateOffset = indexPath.row - (capacity / 2)
        var components = DateComponents()
        components.day = dateOffset
        return Calendar.current.date(byAdding: components, to: Date())
    }
    
    func time(for totalOffset: CGFloat) -> Date? {
        let minutes = Int(totalOffset)
        let hours = minutes / 60
        return Date(hour: hours, minute: minutes % 60)
    }
    
    func taskView(for task: Task) -> ScheduledTaskView {
        let taskView = ScheduledTaskView(task: task)
        
        let dragInteraction = UIDragInteraction(delegate: self)
        dragInteraction.isEnabled = true
        taskView.addInteraction(dragInteraction)
        return taskView
    }
    
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return capacity
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DayViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.day = date(for: indexPath)
        updateCurrentMonthIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        guard let date = date(for: indexPath) else { return }
        
        let items = loadItems(for: date)
        dayScrollView.setNewTasks(items.map({ taskView(for: $0) }))
    }
    
}

extension CalendarViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.localDragSession != nil
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        UIView.animate(withDuration: 0.3) {
            self.schedulingLabel.alpha = 1.0
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: dayScrollView)
        let date = time(for: dropLocation.y)
        schedulingLabel.text = "schedule at \(date!.twentyFourHourString())"
        let view = dayScrollView.hitTest(dropLocation, with: nil)
        if view is ScheduledTaskView {
            let proposal = UIDropProposal(operation: .cancel)
            proposal.isPrecise = true
            return proposal
        } else {
            let proposal = UIDropProposal(operation: .move)
            proposal.isPrecise = true
            return proposal
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        UIView.animate(withDuration: 0.3) {
            self.schedulingLabel.alpha = 0.0
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSURL.self) { (urlArray) in
            let url = urlArray.first as! NSURL
            
            guard let objectId = self.context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url as URL),
                let task = try? self.context.existingObject(with: objectId) as? Task else {
                print("failed fetch")
                return
            }
            guard let selectedIndexPath = self.collectionView.indexPathsForSelectedItems?.first,
                let date = self.date(for: selectedIndexPath) else { return }
            
            let dropLocation = session.location(in: self.dayScrollView)
            let timeOfDay = self.time(for: dropLocation.y)
            let beginning = Date(mergeDay: date, withTime: timeOfDay!)
            task?.time?.beginning = beginning
            let timeDuration = task!.time!.duration!.chunk()
            task?.time?.end = beginning.add(timeDuration)
            do {
                try self.context.save()
            } catch let error {
                print("error saving context: \(error)")
            }
            
            let taskView = ScheduledTaskView(task: task!)
            self.dayScrollView.addAndArrange(for: taskView)
            
            let dragInteraction = UIDragInteraction(delegate: self)
            dragInteraction.isEnabled = true
            taskView.addInteraction(dragInteraction)
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, concludeDrop session: UIDropSession) {
        print("perform drop")
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        UIView.animate(withDuration: 0.3) {
            self.schedulingLabel.alpha = 0.0
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, previewForDropping item: UIDragItem, withDefault defaultPreview: UITargetedDragPreview) -> UITargetedDragPreview? {
        print("preview for dropping")
        return nil
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, item: UIDragItem, willAnimateDropWith animator: UIDragAnimating) {
        print("will animate drop")
    }
    
}

extension CalendarViewController: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let location = session.location(in: dayScrollView)
        guard let view = dayScrollView.hitTest(location, with: nil) as? ScheduledTaskView,
            let task = view.task else { return [] }
        let itemProvider = NSItemProvider(object: task.objectID.uriRepresentation() as NSURL)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = view
        dragItem.previewProvider = {
            return task.makeDragPreview()
        }
        return [dragItem]
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, sessionWillBegin session: UIDragSession) {
        guard let view = session.items.first?.localObject as? ScheduledTaskView else { return }
        if view.alpha == 1.0 {
            view.alpha = 0.0
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, didEndWith operation: UIDropOperation) {
        guard let view = session.items.first?.localObject as? ScheduledTaskView else { return }
        if operation == .cancel {
            UIView.animate(withDuration: 0.3) {
                view.alpha = 1.0
            }
        } else {
            view.removeFromSuperview()
        }
    }
    
}
