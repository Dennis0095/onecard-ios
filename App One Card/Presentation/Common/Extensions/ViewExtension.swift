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
}
