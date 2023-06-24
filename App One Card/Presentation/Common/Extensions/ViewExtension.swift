//
//  ViewExtension.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import UIKit

extension UIView {
    func removeAllConstraints() {
        if let _superview = self.superview {
            self.removeFromSuperview()
            _superview.addSubview(self)
        }
    }
    
    func addShadow(color: UIColor = .black, opacity: Float = 0.5, offset: CGSize = CGSize(width: 2, height: 2), radius: CGFloat = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
}
