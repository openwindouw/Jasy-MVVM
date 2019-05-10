//
//  Date+Helpers.swift
//  Jasy
//
//  Created by User on 11/25/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import Foundation

extension Date {
    
    //from https://stackoverflow.com/a/24777965
    init(from dateString: String, with format: String? = "yyyy-MM-dd") {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        guard let date = dateFormatter.date(from: dateString) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        
        self = date
    }
    
    static var formattedToday: String {
        return Date().formattedDate
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    var yearFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    func startOfMonth() -> Date? {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: comp)!
    }
}
