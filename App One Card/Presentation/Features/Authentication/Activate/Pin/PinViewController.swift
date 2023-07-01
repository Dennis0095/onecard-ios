//
//  PinViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 22/06/23.
//

import UIKit

class PinViewController: BaseViewController {

    @IBOutlet weak var txtPin: OutlinedTextField!
    @IBOutlet weak var keyboardButtons: KeyboardNumber!
    
    var pin: String = ""

    override func initView() {
        txtPin.configure(placeholder: "PIN de la tarjeta", errorMessage: "Debe tener 4 dígitos.", status: .activatedWithMessage, isPassword: true)
    }
    
    override func setActions() {
        keyboardButtons.actionButton = { number in
            if self.pin.count < 4 {
                self.pin.append(number)
                self.txtPin.setText(text: self.pin)
                self.txtPin.status = .activatedWithMessage
            }
        }
        
        keyboardButtons.actionClear = {
            if self.pin.count > 0 {
                self.pin.removeLast()
                self.txtPin.setText(text: self.pin)
                self.txtPin.status = .activatedWithMessage
            }
        }
    }
}
