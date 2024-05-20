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
    @IBOutlet weak var lblAlphanumericUser: UILabel!
    @IBOutlet weak var lblAlphanumericPassword: UILabel!
    @IBOutlet weak var lblSpecialCharacterPassword: UILabel!
    @IBOutlet weak var btnAuthorize: CheckboxButton!
    @IBOutlet weak var lblAuthorize: UILabel!
    
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
        txtPassword.configure(placeholder: Constants.placeholder_password, status: .activated, isPassword: true, maxLength: 12)
        txtConfirmPassword.configure(placeholder: Constants.confirm_your_digital_key, status: .activated, isPassword: true, maxLength: 12)
        btnNext.configure(text: Constants.next_btn, status: .enabled)
        
        txtPassword.txt.textContentType = .oneTimeCode
        txtConfirmPassword.txt.textContentType = .oneTimeCode
        
        connectFields(textFields: txtUser.txt, txtPassword.txt, txtConfirmPassword.txt)
        
        setTerms()
        setAuthorize()
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        let tapTerms = UITapGestureRecognizer(target: self, action: #selector(tapTerms))
        lblTerms.isUserInteractionEnabled = true
        lblTerms.addGestureRecognizer(tapTerms)
        
        let tapAuthorize = UITapGestureRecognizer(target: self, action: #selector(tapAuthorize))
        lblAuthorize.isUserInteractionEnabled = true
        lblAuthorize.addGestureRecognizer(tapAuthorize)
        
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
        if let url = URL(string: GeneralSessionManager.shared.getLink(key: Constants.keyLinkRegister)) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func tapAuthorize() {
        if let url = URL(string: GeneralSessionManager.shared.getLink(key: Constants.keyLinkDataTreatment)) {
            UIApplication.shared.open(url)
        }
    }
    
    private func setTerms() {
        let longString = "Al continuar acepta los Términos y Condiciones"
        let longestWordRange = (longString as NSString).range(of: "Términos y Condiciones")

        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "ProximaNova-Medium", size: 14)!])

        attributedString.setAttributes([NSAttributedString.Key.font: UIFont(name: "ProximaNova-Bold", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor(hexString: "#00A3E0")], range: longestWordRange)
        lblTerms.attributedText = attributedString
    }
    
    private func setAuthorize() {
        let longString = "Autorizo el tratamiento de mis datos personales para fines comerciales y/o publicitarios."
        let longestWordRange = (longString as NSString).range(of: "fines comerciales y/o publicitarios")

        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "ProximaNova-Medium", size: 13)!])

        attributedString.setAttributes([NSAttributedString.Key.font: UIFont(name: "ProximaNova-Bold", size: 13)!, NSAttributedString.Key.foregroundColor: UIColor(hexString: "#00A3E0")], range: longestWordRange)
        lblAuthorize.attributedText = attributedString
    }
    
    private func validate() -> Bool {
        txtUser.errorMessage = txtUser.text.isEmpty ? "Debes ingresar tu usuario" : txtUser.text.count < 8 ? "Mínimo 8 caracteres" : nil
        txtPassword.errorMessage = txtPassword.text.isEmpty ? "Debes ingresar tu clave" : "Debe de contener números, letras y al menos uno de estos caracteres !,@,#,$,%,^,&,*."
        txtConfirmPassword.errorMessage = txtConfirmPassword.text.isEmpty ? "Debes confirmar tu clave" : "Las claves no coinciden"
        
        txtUser.isValid = !txtUser.text.isEmpty && txtUser.text.count > 7
        lblAlphanumericUser.isHidden = !txtUser.isValid
        let isAlphanumericUser = txtUser.text.validateString(withRegex: .alphanumeric)
        lblAlphanumericUser.textColor = isAlphanumericUser ? UIColor(hexString: "#949494") : UIColor(hexString: "#E41313")
        let isValidUser = txtUser.isValid && isAlphanumericUser
        
        txtPassword.isValid = !txtPassword.text.isEmpty
        lblAlphanumericPassword.isHidden = !txtPassword.isValid
        lblSpecialCharacterPassword.isHidden = !txtPassword.isValid
        let isAlphanumericPassword = txtPassword.text.validateString(withRegex: .containLettersAndNumbers) && txtPassword.text.count > 5
        let isSpecialCharacterPassword = txtPassword.text.validateString(withRegex: .passwordContainSpecialCharacters)
        lblAlphanumericPassword.textColor = isAlphanumericPassword ? UIColor(hexString: "#949494") : UIColor(hexString: "#E41313")
        lblSpecialCharacterPassword.textColor = isSpecialCharacterPassword ? UIColor(hexString: "#949494") : UIColor(hexString: "#E41313")
        let isValidPassword = txtPassword.isValid && isAlphanumericPassword && isSpecialCharacterPassword
        
        txtConfirmPassword.isValid = (txtConfirmPassword.text == txtPassword.text) && !txtPassword.text.isEmpty
        
        return isValidUser && isValidPassword && txtConfirmPassword.isValid
    }
    
    @IBAction func next(_ sender: Any) {
        if validate() {
            viewModel.registerUser()
        }
    }
    
    @IBAction func chooseAuthorize(_ sender: Any) {
        viewModel.chooseAuthorize(btnAuthorize.isChecked)
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
