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
    var accept: VoidActionHandler?
    var customTextStyle: VoidActionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActions()
        setupView()
    }
    
    func addActions() { }
    
    func setupView() {
        if let title = titleError, let description = descriptionError {
            lblTitle.text = title
            lblDescription.text = description
            setupAttributedText(description: description)
        }
        
        btnAccept.configure(text: Constants.accept, status: .enabled)
    }
    
    private func setupAttributedText(description: String) {
        let countString = "60 seg"
        
        if description.contains(countString) {
            let longString = "Verifica el código o vuelve a enviar uno nuevo dentro de " + countString
            let longestWordRange = (longString as NSString).range(of: countString)
            
            let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "ProximaNova-Medium", size: 15)!])
            
            attributedString.setAttributes([NSAttributedString.Key.font: UIFont(name: "ProximaNova-Bold", size: 15)!], range: longestWordRange)
            lblDescription.attributedText = attributedString
        }
    }
    
    @IBAction func clickAccept(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true) {
            if let completion = self.accept {
                completion()
            }
        }
    }
    
}
