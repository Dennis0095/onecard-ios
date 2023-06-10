//
//  LoginInformationViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 9/06/23.
//

import UIKit

class LoginInformationViewController: UIViewController {

    @IBOutlet weak var txtUser: OutlinedTextField!
    @IBOutlet weak var txtPassword: OutlinedTextField!
    @IBOutlet weak var txtConfirmPassword: OutlinedTextField!
    private var viewModel: LoginInformationViewModelProtocol
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    
    init(viewModel: LoginInformationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtUser.configure(placeholder: Constants.placeholder_user, status: .activated)
        txtPassword.configure(placeholder: Constants.placeholder_password, status: .activated, isPassword: true)
        txtConfirmPassword.configure(placeholder: Constants.placeholder_password, status: .activated, isPassword: true)
        btnNext.configure(text: Constants.next_btn, status: .enabled)
    }
    
    @IBAction func next(_ sender: Any) {
        viewModel.successfulRegister { [weak self] in
            self?.viewModel.toLogin()
        }
    }
}
