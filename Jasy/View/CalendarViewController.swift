//
//  CalendarViewController.swift
//  Jasy
//
//  Created by Vladimir Espinola on 10/02/2019.
//  Copyright © 2019 Vladimir Espinola. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    @IBOutlet weak var calendar: FSCalendar!
    
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Calendar"
        
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.allowsMultipleSelection = true
        
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            
            return
        }
        
        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                return
            }
            
            return
        }
        
        // both are selected:
        if firstDate != nil && lastDate != nil {
            
            lastDate = nil
            firstDate = nil
        
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:
        
        // NOTE: the is a REDUANDENT CODE:
        if firstDate != nil && lastDate != nil {
            
            lastDate = nil
            firstDate = nil
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("adio")
    }
}

extension CalendarViewController: FSCalendarDataSource {
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date(from: NasaConstants.minimumStartingPoint)
    }
}
