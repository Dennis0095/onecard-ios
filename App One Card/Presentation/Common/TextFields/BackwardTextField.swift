//
//  BackwardTextField.swift
//  App One Card
//
//  Created by Paolo Arambulo on 7/06/23.
//

import UIKit

class BackwardTextField: UITextField {
    var backspaceCalled: (() -> Void)?
    
    override func deleteBackward() {
        super.deleteBackward()
        backspaceCalled?()
    }
}
