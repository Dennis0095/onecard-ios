//
//  EditUserViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/06/23.
//

typealias EditUserSuccessActionHandler = ((_ username: String) -> Void)

import UIKit

class EditUserViewController: BaseViewController {
    @IBOutlet weak var txtUser: OutlinedTextField!
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var viewModel: EditUserViewModelProtocol
    
    var success: EditUserSuccessActionHandler?
    
    init(viewModel: EditUserViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        txtUser.configure(placeholder: "Nuevo usuario", status: .activated)
        btnNext.configure(text: Constants.next_btn, status: .enabled)
        
        connectFields(textFields: txtUser.txt)
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        [txtUser].forEach {
            $0.selectTextField = { textField in
                self.selectedTextField = textField
            }
        }
        
        txtUser.listenChanges = { [weak self] text in
            self?.viewModel.newUsername = text
        }
    }
    
    override func manageScroll() {
        self.baseScrollView = scrollView
    }
    
    private func validate() -> Bool {
        txtUser.errorMessage = txtUser.text.isEmpty ? "Debe ingresar el nuevo usuario." : "Debe contener números y letras"
        txtUser.isValid = txtUser.text.validateString(withRegex: .containLettersAndNumbers)
        
        return txtUser.isValid
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        if validate() {
            viewModel.updateUsername()
        }
    }
}

extension EditUserViewController: EditUserViewModelDelegate {
    func succesUpdate(username: String) {
        if let completion = success {
            completion(username)
        }
        viewModel.successfulEdit()
    }
}
