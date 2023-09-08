//
//  ChangePasswordViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 20/07/23.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    @IBOutlet weak var txtCurrentPassword: OutlinedTextField!
    @IBOutlet weak var txtNewPassword: OutlinedTextField!
    @IBOutlet weak var txtConfirmPassword: OutlinedTextField!
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var viewModel: ChangePasswordViewModelProtocol
    
    init(viewModel: ChangePasswordViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        txtCurrentPassword.configure(placeholder: "Clave actual", status: .activated, isPassword: true)
        txtNewPassword.configure(placeholder: "Nueva clave digital", status: .activated, isPassword: true)
        txtConfirmPassword.configure(placeholder: "Confirmación de clave", status: .activated, isPassword: true)
        btnNext.configure(text: Constants.next_btn, status: .enabled)
        
        connectFields(textFields: txtCurrentPassword.txt, txtNewPassword.txt, txtConfirmPassword.txt)
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        [txtCurrentPassword, txtNewPassword, txtConfirmPassword].forEach {
            $0.selectTextField = { textField in
                self.selectedTextField = textField
            }
        }
        
        txtCurrentPassword.listenChanges = { [weak self] text in
            self?.viewModel.password = text
        }
        
        txtNewPassword.listenChanges = { [weak self] text in
            self?.viewModel.newPassword = text
        }
        
        txtConfirmPassword.listenChanges = { [weak self] text in
            self?.viewModel.passwordOk = text
        }
    }
    
    override func manageScroll() {
        self.baseScrollView = scrollView
    }
    
    private func validate() -> Bool {
        txtCurrentPassword.errorMessage = txtCurrentPassword.text.isEmpty ? "Debe ingresar su clave actual." : ""
        txtNewPassword.errorMessage = txtNewPassword.text.isEmpty ? "Debe ingresar su nueva clave." : "Debe de contener números, letras y al menos uno de estos caracteres !,@,#,$,%,^,&,*."
        txtConfirmPassword.errorMessage = txtConfirmPassword.text.isEmpty ? "Debe confirmar su nueva clave." : "Las claves no coinciden."
        
        txtCurrentPassword.isValid = !txtCurrentPassword.text.isEmpty
        txtNewPassword.isValid = txtNewPassword.text.validateString(withRegex: .passwordContainSpecialCharacters)
        txtConfirmPassword.isValid = (txtConfirmPassword.text == txtNewPassword.text) && !txtNewPassword.text.isEmpty
        
        return txtCurrentPassword.isValid && txtNewPassword.isValid && txtConfirmPassword.isValid
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        if validate() {
            viewModel.updatePassword()
        }
    }
}

extension ChangePasswordViewController: ChangePasswordViewModelDelegate {
    func succesUpdate() {
        viewModel.successfulEdit()
    }
}
