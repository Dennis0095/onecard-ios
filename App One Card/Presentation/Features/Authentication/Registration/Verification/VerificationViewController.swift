//
//  VerificationViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import UIKit

class VerificationViewController: UIViewController {

    @IBOutlet weak var txtCode: CodeVerificationTextField!
    @IBOutlet weak var imgBack: UIImageView!
    
    private var viewModel: VerificationViewModelProtocol
    
    init(viewModel: VerificationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActions()
    }

    func addActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        txtCode.configure()
        txtCode.didEnterLastDigit = { [weak self] code in
            print(code)
            
        }
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
