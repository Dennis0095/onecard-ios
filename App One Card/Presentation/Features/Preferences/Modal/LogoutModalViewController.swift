//
//  LogoutModalViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 18/08/23.
//

import UIKit

class LogoutModalViewController: UIViewController {

    @IBOutlet weak var btnCancel: PrimaryOutlineButton!
    @IBOutlet weak var btnAccept: PrimaryFilledButton!
    
    var accept: VoidActionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCancel.configure(text: "Cancelar")
        btnAccept.configure(text: "Cerrar sesión", status: .enabled)
    }
    
    @IBAction func clickAccept(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true) {
            if let completion = self.accept {
                completion()
            }
        }
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
