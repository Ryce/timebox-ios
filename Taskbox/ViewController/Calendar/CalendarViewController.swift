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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.addDropShadow()
        
        dayScrollView.addInteraction(UIDropInteraction(delegate: self))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCurrentMonthIfNeeded()
        let indexPath = IndexPath(row: capacity / 2, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
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
        let dateOffset = indexPath.row - (capacity / 2)
        var components = DateComponents()
        components.day = dateOffset
        cell.day = Calendar.current.date(byAdding: components, to: Date())
        updateCurrentMonthIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
        let dropLocation = session.location(in: view)
        let minutes = Int(dropLocation.y + dayScrollView.contentOffset.y)
        let hours = minutes / 60
        schedulingLabel.text = "schedule at \(hours):\(minutes % 60)"
        let proposal = UIDropProposal(operation: .move)
        proposal.isPrecise = true
        return proposal
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
            print("task \(task)")
        }
        print("perform drop")
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
        print(defaultPreview)
        guard let taskItem = item as? TaskDragItem else { return nil }
        print(taskItem)
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        view.backgroundColor = .green
        return UITargetedDragPreview(view: view)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, item: UIDragItem, willAnimateDropWith animator: UIDragAnimating) {
        
    }
    
}
