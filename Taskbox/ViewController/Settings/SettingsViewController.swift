//
//  SettingsViewController.swift
//  Taskbox
//
//  Created by Hamon Riazy on 14/05/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    enum Section {
        static let clock = 0
        static let notificationSettings = 1
        static let otherSettings = 2
        
        static let allValues = [clock, notificationSettings, otherSettings]
    }
    
    enum ClockRow {
        static let timeSelection = 0
        
        static let allValues = [timeSelection]
    }
    
    enum NotificationSettingsRow {
        static let taskStartAlert = 0
        static let taskEndAlert = 1
        
        static let allValues = [taskStartAlert, taskEndAlert]
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.clock:
            return 1
        case Section.notificationSettings:
            return 2
        case Section.otherSettings:
            return 3
        default:
            fatalError("Section index out of bounds")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        switch indexPath.section {
        case Section.clock:
            return cell
        case Section.notificationSettings:
            return cell
        case Section.otherSettings:
            return cell
        default:
            fatalError("Section index out of bounds")
        }
    }
    
}
