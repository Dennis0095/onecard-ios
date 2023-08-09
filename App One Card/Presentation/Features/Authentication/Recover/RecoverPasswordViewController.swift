//
//  RecoverPasswordViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 8/08/23.
//

import UIKit

class RecoverPasswordViewController: BaseViewController {

    @IBOutlet weak var txtPassword: OutlinedTextField!
    @IBOutlet weak var txtConfirmPassword: OutlinedTextField!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var viewModel: RecoverPasswordViewModelProtocol
    
    init(viewModel: RecoverPasswordViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        txtPassword.configure(placeholder: "Nueva clave digital", status: .activated, isPassword: true)
        txtConfirmPassword.configure(placeholder: "Confirme su nueva clave digital", status: .activated, isPassword: true)
        btnNext.configure(text: Constants.next_btn, status: .enabled)
        
        txtPassword.txt.textContentType = .oneTimeCode
        txtConfirmPassword.txt.textContentType = .oneTimeCode
        
        connectFields(textFields: txtPassword.txt, txtConfirmPassword.txt)
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        [txtPassword, txtConfirmPassword].forEach {
            $0.selectTextField = { textField in
                self.selectedTextField = textField
            }
        }
        
        txtPassword.listenChanges = { [weak self] text in
            self?.viewModel.password = text
        }
        
        txtConfirmPassword.listenChanges = { [weak self] text in
            self?.viewModel.passwordOk = text
        }
    }
    
    override func manageScroll() {
        self.baseScrollView = scrollView
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func validate() -> Bool {
        txtPassword.errorMessage = txtPassword.text.isEmpty ? "Debe ingresar su clave." : "Debe contener números y letras."
        txtConfirmPassword.errorMessage = txtConfirmPassword.text.isEmpty ? "Debe confirmar su clave." : "Las claves no coinciden."
        
        txtPassword.isValid = txtPassword.text.validateString(withRegex: .alphanumeric)
        txtConfirmPassword.isValid = (txtConfirmPassword.text == txtPassword.text) && !txtPassword.text.isEmpty

        return txtPassword.isValid && txtConfirmPassword.isValid
    }
    
    @IBAction func next(_ sender: Any) {
        if validate() {
            viewModel.recoverPassword()
        }
    }
}

extension RecoverPasswordViewController: RecoverPasswordViewModelDelegate {
    
    func success() {
        viewModel.navigateToSuccessfulScreen()
    }

}
