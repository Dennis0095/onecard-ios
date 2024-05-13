//
//  PromotionTermsViewController.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 13/05/24.
//

import UIKit

class PromotionTermsViewController: UIViewController {

    @IBOutlet weak var viewReturn: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblTerms: UILabel!
    
    private let termsConditions: String
    
    init(termsConditions: String) {
        self.termsConditions = termsConditions
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addActions()
        
        viewReturn.clipsToBounds = true
        viewReturn.layer.cornerRadius = 5
        
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 10
        
        lblTerms.text = termsConditions
    }

    private func addActions() {
        let tapClose = UITapGestureRecognizer(target: self, action: #selector(tapClose))
        viewReturn.isUserInteractionEnabled = true
        viewReturn.addGestureRecognizer(tapClose)
    }
    
    @objc
    private func tapClose() {
        self.dismiss(animated: true)
    }
    
}
