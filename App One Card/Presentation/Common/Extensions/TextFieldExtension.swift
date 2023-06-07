//
//  TextFieldExtension.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

extension UITextField {
    
    func setFont(_ font: UIFont, _ color: UIColor) {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font : font
        ]
        
        self.defaultTextAttributes = textAttributes
    }
    
    func setPlaceholderFont(_ placeholder: String? = "", _ font: UIFont, _ color: UIColor) {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font : font
        ]
        
        self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: placeholderAttributes)
    }
}

