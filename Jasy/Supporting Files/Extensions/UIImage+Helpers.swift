//
//  UIImage+Helpers.swift
//  Jasy
//
//  Created by User on 11/25/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(width: CGFloat, heigth: CGFloat) -> UIImage?{
        let newSize = CGSize(width: width, height: heigth)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

