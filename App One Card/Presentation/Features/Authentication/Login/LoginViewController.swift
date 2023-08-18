//
//  LoginViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var txtUser: OutlinedTextField!
    @IBOutlet weak var txtPassword: OutlinedTextField!
    @IBOutlet weak var btnLogin: PrimaryFilledButton!
    @IBOutlet weak var btnRegister: PrimaryOutlineButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var viewModel: LoginViewModelProtocol
    
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        txtUser.configure(placeholder: Constants.placeholder_user, status: .activated)
        txtPassword.configure(placeholder: Constants.placeholder_password, status: .activated, isPassword: true)
        btnLogin.configure(text: Constants.login_btn, status: .enabled)
        btnRegister.configure(text: Constants.login_register_btn)
        
        connectFields(textFields: txtUser.txt, txtPassword.txt)
    }
    
    override func manageScroll() {
        self.baseScrollView = scrollView
    }
    
    override func setActions() {
        [txtUser, txtPassword].forEach {
            $0.selectTextField = { textField in
                self.selectedTextField = textField
            }
        }
        
        txtUser.listenChanges = { [weak self] text in
            self?.viewModel.username = text
        }
        
        txtPassword.listenChanges = { [weak self] text in
            self?.viewModel.password = text
        }
        
        viewModel.username = "A"
        viewModel.password = "A"
    }
    
    @IBAction func login(_ sender: Any) {
        viewModel.login()
    }
    
    @IBAction func register(_ sender: Any) {
        viewModel.toRegister()
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        viewModel.toForgotPassword()
    }
    
}

extension LoginViewController: LoginViewModelDelegate { }
