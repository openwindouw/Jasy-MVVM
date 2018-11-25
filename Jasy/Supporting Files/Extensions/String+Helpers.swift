//
//  String+Helpers.swift
//  Jasy
//
//  Created by User on 11/25/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import Foundation

extension String {
    var trimmed: String? {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
