//
//  EditMailViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/06/23.
//

typealias EditMailSuccessActionHandler = ((_ username: String) -> Void)

import UIKit

class EditMailViewController: BaseViewController {

    @IBOutlet weak var txtMail: OutlinedTextField!
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    @IBOutlet weak var imgBack: UIImageView!
    
    private var viewModel: EditMailViewModelProtocol
    
    var success: EditMailSuccessActionHandler?
    
    init(viewModel: EditMailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        txtMail.configure(placeholder: Constants.placeholder_email, status: .activated, type: .emailAddress)
        btnNext.configure(text: Constants.next_btn, status: .enabled)
        
        connectFields(textFields: txtMail.txt)
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        [txtMail].forEach {
            $0.selectTextField = { textField in
                self.selectedTextField = textField
            }
        }
        
        txtMail.listenChanges = { [weak self] text in
            self?.viewModel.newEmail = text
        }
    }
    
    private func validate() -> Bool {
        txtMail.errorMessage = txtMail.text.isEmpty ? "Ingresa el correo electrónico." : "Ingresa un correo válido."
        
        txtMail.isValid = txtMail.text.validateString(withRegex: .email)
        
        return txtMail.isValid
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        if validate() {
            viewModel.updateEmail()
        }
    }
}

extension EditMailViewController: EditMailViewModelDelegate {
    func succesUpdate(email: String) {
        if let completion = success {
            completion(email)
        }
        viewModel.successfulEdit()
    }
}
