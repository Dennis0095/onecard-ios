//
//  AlertErrorViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 14/06/23.
//

import UIKit

class AlertErrorViewController: UIViewController {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnAccept: PrimaryFilledButton!
    
    var titleError: String?
    var descriptionError: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActions()
        setupView()
    }
    
    func addActions() {
        let tapHidden = UITapGestureRecognizer(target: self, action: #selector(hiddenAlert))
        viewBackground.isUserInteractionEnabled = true
        viewBackground.addGestureRecognizer(tapHidden)
    }
    
    func setupView() {
        viewContainer.layer.cornerRadius = 15
        viewContainer.layer.masksToBounds = true
        
        if let title = titleError, let description = descriptionError {
            lblTitle.text = title
            lblDescription.text = description
        }
        
        btnAccept.configure(text: Constants.accept, status: .enabled)
    }
    
    @objc
    func hiddenAlert() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickAccept(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
