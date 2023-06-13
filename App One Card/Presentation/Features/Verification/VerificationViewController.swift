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
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var lblStep: UILabel!
    
    private var viewModel: VerificationViewModelProtocol
    private var navTitle: String
    private var step: String
    
    init(viewModel: VerificationViewModelProtocol, navTitle: String, step: String) {
        self.viewModel = viewModel
        self.navTitle = navTitle
        self.step = step
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActions()
        configure()
        btnNext.configure(text: Constants.next_btn, status: .enabled)
    }

    private func addActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        txtCode.configure()
        txtCode.didEnterLastDigit = { [weak self] code in

        }
    }
    
    private func configure() {
        lblNavTitle.text = navTitle
        lblStep.text = step
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        viewModel.successVerification()
    }
}
