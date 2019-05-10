//
//  Utils.swift
//  Jasy
//
//  Created by Vladimir Espinola on 9/15/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit

struct Utilities {
    private init() {}
    
    static func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
    static func share(items: [Any], in viewController: UIViewController) {
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: items, applicationActivities: nil)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.unknown
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
//            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    static func convert(currentDate: String, in currentFormat: String = DateFormats.year, to newFormat: String = DateFormats.default) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormat
        guard let date = dateFormatter.date(from: currentDate) else { return "" }
        dateFormatter.dateFormat = newFormat
        return  dateFormatter.string(from: date)
    }
    
    static func getDate(from currentDate: String, currentFormat: String = DateFormats.default) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormat
        
        return dateFormatter.date(from: currentDate)
    }
}
