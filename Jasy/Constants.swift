//
//  Constants.swift
//  Jasy
//
//  Created by Vladimir Espinola on 9/15/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit

struct JUserDefaultsKeys {
    static let currentMonth = "current_month"
    
    static let selectedStartDate = "selected_start_date"
    static let selectedEndDate = "selected_end_date"
}

struct DateFormats {
    static let year = "yyyy"
    static let `default` = "yyyy-MM-dd"
    static let pretty = "LLLL dd, yyyy"
}

struct JMetric {
    static let cornerRadius: CGFloat = 6
    static let borderWidth: CGFloat = 1
    static let standardMinSpace: CGFloat = 8
}
