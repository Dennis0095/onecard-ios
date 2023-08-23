//
//  SuccessfulViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 9/06/23.
//

typealias VoidActionHandler = (() -> Void)

import UIKit

class SuccessfulViewController: BaseViewController {
    @IBOutlet weak var imgSuccess: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSuccessful: PrimaryFilledButton!
    
    var accept: VoidActionHandler?
    var titleSuccessful: String?
    var descriptionSuccessful: String?
    var buttonSuccessful: String?
    var imageSuccessful: UIImage?
    
    override func initView() {
        configure()
    }
    
    func configure() {
        lblTitle.text = titleSuccessful
        lblDescription.text = descriptionSuccessful
        btnSuccessful.configure(text: buttonSuccessful ?? Constants.accept, status: .enabled)
        imgSuccess.image = imageSuccessful
    }
    
    @IBAction func ok(_ sender: Any) {
        if let action = accept {
            action()
        }
    }
}
