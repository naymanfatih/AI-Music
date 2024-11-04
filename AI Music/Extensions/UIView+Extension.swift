//
//  GradientDirection.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 4.11.2024.
//


import UIKit

extension UIView {
    enum GradientDirection {
        case topToBottom
        case topLeftToBottomRight
        
        var points: (start: CGPoint, end: CGPoint) {
            switch self {
            case .topToBottom:
                return (start: CGPoint(x: 0.5, y: 0.0), end: CGPoint(x: 0.5, y: 1.0))
            case .topLeftToBottomRight:
                return (start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: 1.0, y: 1.0))
            }
        }
    }
    
    func applyGradient(colors: [UIColor], direction: GradientDirection = .topToBottom, cornerRadius: CGFloat = 0) {
        removeGradientLayers()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = direction.points.start
        gradientLayer.endPoint = direction.points.end
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = cornerRadius
        
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.cornerRadius = cornerRadius
        maskLayer.frame = self.bounds
        gradientLayer.mask = maskLayer
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func removeGradientLayers() {
        self.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
    }
}
