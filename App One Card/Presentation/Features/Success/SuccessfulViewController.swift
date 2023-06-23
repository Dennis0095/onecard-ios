//
//  SuccessfulViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 9/06/23.
//

typealias VoidActionHandler = (() -> Void)

import UIKit

class SuccessfulViewController: UIViewController {
    @IBOutlet weak var imgSuccess: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSuccessful: PrimaryFilledButton!
    
    var accept: VoidActionHandler?
    var titleSuccessful: String?
    var descriptionSuccessful: String?
    var buttonSuccessful: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configure()
        btnSuccessful.configure(text: buttonSuccessful ?? Constants.enter, status: .enabled)
    }
    
    func configure() {
        lblTitle.text = titleSuccessful
        lblDescription.text = descriptionSuccessful
    }
    
    @IBAction func ok(_ sender: Any) {
        if let action = accept {
            action()
        }
    }
}
