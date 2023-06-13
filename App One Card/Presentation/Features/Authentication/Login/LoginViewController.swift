//
//  LoginViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUser: OutlinedTextField!
    @IBOutlet weak var txtPassword: OutlinedTextField!
    @IBOutlet weak var btnLogin: PrimaryFilledButton!
    @IBOutlet weak var btnRegister: PrimaryOutlineButton!
    
    private var viewModel: LoginViewModelProtocol
    
    init(viewModel: LoginViewModelProtocol) {
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
        btnLogin.configure(text: Constants.login_btn, status: .enabled)
        btnRegister.configure(text: Constants.login_register_btn)
    }
    @IBAction func login(_ sender: Any) {
        viewModel.toHome()
    }
    
    @IBAction func register(_ sender: Any) {
        viewModel.toRegister()
    }
}
