//
//  UITextField+Helpers.swift
//  Jasy
//
//  Created by Vladimir Espinola on 3/18/19.
//  Copyright © 2019 Vladimir Espinola. All rights reserved.
//

import UIKit

extension UITextField {
    func addDoneButton(callback: (() -> Void)? = nil) {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = true
        toolbar.tintColor = .primary
        toolbar.backgroundColor = .white
        let closeBarButtonItem = BarButtonItem(title: "Done", onClick: { _ in
            self.resignFirstResponder()
            callback?()
        })
        let spaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceBarButtonItem, closeBarButtonItem], animated: false)
        let toolbarWrapperView = UIView()
        toolbarWrapperView.addSubview(toolbar)
        
        toolbar.snp.makeConstraints { make in
            make.margins.equalTo(0)
        }
        
        self.inputAccessoryView = toolbar
        self.inputAccessoryView!.backgroundColor = UIColor.white
    }
}
