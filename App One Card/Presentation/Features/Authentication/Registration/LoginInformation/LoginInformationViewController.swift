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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblTerms: UILabel!
    
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
        
        connectFields(textFields: txtUser.txt, txtPassword.txt, txtConfirmPassword.txt)
        
        setTerms()
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        let tapTerms = UITapGestureRecognizer(target: self, action: #selector(tapTerms))
        lblTerms.isUserInteractionEnabled = true
        lblTerms.addGestureRecognizer(tapTerms)
        
        [txtUser, txtPassword, txtConfirmPassword].forEach {
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
    
    @objc private func tapTerms() {
        if let url = URL(string: "https://www.google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func setTerms() {
        let longString = "Al continuar acepta los Términos y condiciones"
        let longestWordRange = (longString as NSString).range(of: "Términos y condiciones")

        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "ProximaNova-Medium", size: 14)!])

        attributedString.setAttributes([NSAttributedString.Key.font: UIFont(name: "ProximaNova-Bold", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor(hexString: "#00A3E0")], range: longestWordRange)
        lblTerms.attributedText = attributedString
    }
    
    private func validate() -> Bool {
        txtUser.errorMessage = txtUser.text.isEmpty ? "Debe ingresar su usuario." : "Debe contener números y letras."
        txtPassword.errorMessage = txtPassword.text.isEmpty ? "Debe ingresar su clave." : txtPassword.text.count < 6 ? "Mínimo 6 caracteres." : "Debe de contener números, letras y al menos uno de estos caracteres !,@,#,$,%,^,&,*."
        txtConfirmPassword.errorMessage = txtConfirmPassword.text.isEmpty ? "Debe confirmar su clave." : "Las claves no coinciden."
        
        txtUser.isValid = txtUser.text.validateString(withRegex: .alphanumeric)
        txtPassword.isValid = txtPassword.text.validateString(withRegex: .passwordContainSpecialCharacters)
        txtConfirmPassword.isValid = (txtConfirmPassword.text == txtPassword.text) && !txtPassword.text.isEmpty

        return txtUser.isValid && txtPassword.isValid && txtConfirmPassword.isValid
    }
    
    @IBAction func next(_ sender: Any) {
        if validate() {
            viewModel.registerUser()
        }
    }
}

extension LoginInformationViewController: LoginInformationViewModelDelegate {
    func successRegister() {
        viewModel.navigateToSuccessfulScreen()
    }
    
    func timeExpired() {
        viewModel.timeExpiredRegister()
    }
}
