//
//  UIButton+Helpers.swift
//  Jasy
//
//  Created by Vladimir Espinola on 10/02/2019.
//  Copyright © 2019 Vladimir Espinola. All rights reserved.
//

import UIKit

extension UIButton {
    func toBarButtonItem() -> UIBarButtonItem? {
        return UIBarButtonItem(customView: self)
    }
}
