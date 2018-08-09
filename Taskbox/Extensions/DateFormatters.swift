//
//  DateFormatters.swift
//  Taskbox
//
//  Created by Hamon Riazy on 16/05/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import Foundation

let weekdayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    return formatter
}()

let simpleDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

let simpleTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    return formatter
}()
