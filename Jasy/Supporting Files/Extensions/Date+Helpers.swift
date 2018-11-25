//
//  Date+Helpers.swift
//  Jasy
//
//  Created by User on 11/25/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import Foundation

extension Date {
    
    static var formattedToday: String {
        return Date().formattedDate
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func startOfMonth() -> Date? {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: comp)!
    }
}
