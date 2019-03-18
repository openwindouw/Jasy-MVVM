//
//  CalendarViewController.swift
//  Jasy
//
//  Created by Vladimir Espinola on 10/02/2019.
//  Copyright © 2019 Vladimir Espinola. All rights reserved.
//

import UIKit
import FSCalendar
import RxSwift

typealias CalendarSelection = (start: Date, end: Date)

class CalendarViewController: UIViewController {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var yearTextField: UITextField!
    
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    
    private var _selectedYearsSubject = PublishSubject<CalendarSelection>()
    
    var selectedYearsObservable: Observable<CalendarSelection>? {
        return _selectedYearsSubject.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Calendar"
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = true
        
        yearTextField.text = calendar.currentPage.yearFormat
        yearTextField.keyboardType = .numberPad
        yearTextField.placeholder = "Year"
        yearTextField.addDoneButton() { [unowned self] in self.dateDidEndEditing() }
        yearTextField.rightViewMode = .always
        
        let rightView = UIView(frame: CGRect(x: JMetric.standardMinSpace, y: JMetric.standardMinSpace, width: 44, height: 44))
        
        let editImage = R.image.edit()!
            .withRenderingMode(.alwaysTemplate)
            .tinted(with: .primary)
        
        let editImageView = UIImageView(image: editImage)
        editImageView.frame = CGRect(x: JMetric.standardMinSpace, y: JMetric.standardMinSpace, width: 30, height: 30)
        rightView.addSubview(editImageView)
        
        yearTextField.rightView = rightView
    }
    
    deinit {
        _selectedYearsSubject.dispose()
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if firstDate == nil {
            firstDate = date
        } else if lastDate == nil { // only first date is selected:
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                lastDate = firstDate
                firstDate = date
            } else {
                lastDate = date
            }
            
            _selectedYearsSubject.onNext(CalendarSelection(start: firstDate!, end: lastDate!))
            navigationController?.popViewController(animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        yearTextField.text = calendar.currentPage.yearFormat
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

extension CalendarViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        dateDidEndEditing()
    }
}

extension CalendarViewController {
    private func dateDidEndEditing() {
        guard let dateString = yearTextField.text else { return }
        guard var date = Utilities.getDate(from: dateString, currentFormat: DateFormats.year) else { return }
        
        if let minimunDate = Utilities.getDate(from: NasaConstants.minimumStartingPoint), date < minimunDate {
            date = minimunDate
        } else if date > Date() {
            date = Date()
        }
        yearTextField.text = date.yearFormat
        calendar.setCurrentPage(date, animated: true)
        
        firstDate = nil
        lastDate = nil
    }
}
