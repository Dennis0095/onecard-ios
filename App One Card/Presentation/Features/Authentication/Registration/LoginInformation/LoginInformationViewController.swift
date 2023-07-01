//
//  LoginInformationViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 9/06/23.
//

import UIKit

class LoginInformationViewController: BaseViewController {

    @IBOutlet weak var txtUser: OutlinedTextField!
    @IBOutlet weak var txtPassword: OutlinedTextField!
    @IBOutlet weak var txtConfirmPassword: OutlinedTextField!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    
    private var viewModel: LoginInformationViewModelProtocol
    
    init(viewModel: LoginInformationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        txtUser.configure(placeholder: Constants.placeholder_user, status: .activated)
        txtPassword.configure(placeholder: Constants.placeholder_password, status: .activated, isPassword: true)
        txtConfirmPassword.configure(placeholder: Constants.placeholder_password, status: .activated, isPassword: true)
        btnNext.configure(text: Constants.next_btn, status: .enabled)
        
        txtPassword.txt.textContentType = .oneTimeCode
        txtConfirmPassword.txt.textContentType = .oneTimeCode
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        txtUser.listenChanges = { [weak self] text in
            self?.viewModel.username = text
        }
        
        txtPassword.listenChanges = { [weak self] text in
            self?.viewModel.password = text
        }
        
        txtConfirmPassword.listenChanges = { [weak self] text in
            self?.viewModel.passwordOk = text
        }
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func validate() -> Bool {
        txtUser.errorMessage = txtUser.text.isEmpty ? "Debe ingresar su usuario." : "Debe contener números y letras."
        txtPassword.errorMessage = txtPassword.text.isEmpty ? "Debe ingresar su clave." : "Debe contener números y letras."
        txtConfirmPassword.errorMessage = txtConfirmPassword.text.isEmpty ? "Debe confirmar su clave." : "Las claves no coinciden."
        
        txtUser.isValid = txtUser.text.validateString(withRegex: .alphanumeric)
        txtPassword.isValid = txtPassword.text.validateString(withRegex: .alphanumeric)
        txtConfirmPassword.isValid = (txtConfirmPassword.text == txtPassword.text) && !txtPassword.text.isEmpty

        return txtUser.isValid && txtPassword.isValid && txtConfirmPassword.isValid
    }
    
    @IBAction func next(_ sender: Any) {
        if validate() {
            viewModel.registerUser()
        }
    }
}
