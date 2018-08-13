//
//  CalendarViewController.swift
//  Taskbox
//
//  Created by Hamon Riazy on 10/05/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit
import QuartzCore

class CalendarViewController: UIViewController {
    
    let monthOnlyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    private let capacity = 1000000
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var monthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.addDropShadow()
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
