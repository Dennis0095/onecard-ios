//
//  PaddedTextField.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import Foundation

import UIKit

@IBDesignable
class PaddedTextField: UITextField {
    
    @IBInspectable var showKeyboard: Bool = true
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    @IBInspectable var paddingTop: CGFloat = 0
    @IBInspectable var paddingBottom: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override var canBecomeFirstResponder: Bool {
        return showKeyboard
    }
}
