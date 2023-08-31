//
//  InactivityModalViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 16/08/23.
//

import UIKit

class InactivityModalViewController: UIViewController {

    @IBOutlet weak var btnContinue: PrimaryFilledButton!
    @IBOutlet weak var btnCloseSession: PrimaryOutlineButton!
    @IBOutlet weak var viewBackground: UIView!
    
    var accept: VoidActionHandler?
    var closeSession: VoidActionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCloseSession.configure(text: "Cerrar sesión")
        btnContinue.configure(text: "Continuar", status: .enabled)
        
        viewBackground.layer.cornerRadius = 16.0
        viewBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @IBAction func clickContinue(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true) {
            if let completion = self.accept {
                completion()
            }
        }
    }
    
    @IBAction func clickCloseSession(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true) {
            if let completion = self.closeSession {
                completion()
            }
        }
    }
}
