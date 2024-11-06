//
//  UIImage+Extension.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 6.11.2024.
//

import UIKit

extension UIImage {
    static func circle(diameter: CGFloat, color: UIColor) -> UIImage? {
        let size = CGSize(width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
