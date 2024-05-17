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
    @IBOutlet weak var viewBackground: UIView!
    
    var accept: VoidActionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCancel.configure(text: Constants.cancel)
        btnAccept.configure(text: Constants.close_session, status: .enabled)
        
        viewBackground.layer.cornerRadius = 16.0
        viewBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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
