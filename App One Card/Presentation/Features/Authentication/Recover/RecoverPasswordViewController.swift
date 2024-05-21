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
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var lblAlphanumericPassword: UILabel!
    @IBOutlet weak var lblSpecialCharacterPassword: UILabel!
    
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
        txtConfirmPassword.configure(placeholder: "Confirma tu nueva clave digital", status: .activated, isPassword: true)
        btnNext.configure(text: Constants.next_btn, status: .enabled)
        
        txtPassword.txt.textContentType = .oneTimeCode
        txtConfirmPassword.txt.textContentType = .oneTimeCode
        
        connectFields(textFields: txtPassword.txt, txtConfirmPassword.txt)
        
        setTerms()
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        let tapTerms = UITapGestureRecognizer(target: self, action: #selector(tapTerms))
        lblTerms.isUserInteractionEnabled = true
        lblTerms.addGestureRecognizer(tapTerms)
        
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
    
    private func setTerms() {
        let longString = "Al continuar aceptas los Términos y Condiciones"
        let longestWordRange = (longString as NSString).range(of: "Términos y Condiciones")

        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "ProximaNova-Medium", size: 14)!])

        attributedString.setAttributes([NSAttributedString.Key.font: UIFont(name: "ProximaNova-Bold", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor(hexString: "#00A3E0")], range: longestWordRange)
        lblTerms.attributedText = attributedString
    }
    
    private func validate() -> Bool {
        txtPassword.errorMessage = txtPassword.text.isEmpty ? "Debes ingresar tu clave." : nil
        txtConfirmPassword.errorMessage = txtConfirmPassword.text.isEmpty ? "Debes confirmar tu clave." : "Las claves no coinciden"
        
        txtPassword.isValid = !txtPassword.text.isEmpty
        lblAlphanumericPassword.isHidden = !txtPassword.isValid
        lblSpecialCharacterPassword.isHidden = !txtPassword.isValid
        let isAlphanumericPassword = txtPassword.text.validateString(withRegex: .containLettersAndNumbers) && txtPassword.text.count > 5
        let isSpecialCharacterPassword = txtPassword.text.validateString(withRegex: .passwordContainSpecialCharacters)
        lblAlphanumericPassword.textColor = isAlphanumericPassword ? UIColor(hexString: "#949494") : UIColor(hexString: "#E41313")
        lblSpecialCharacterPassword.textColor = isSpecialCharacterPassword ? UIColor(hexString: "#949494") : UIColor(hexString: "#E41313")
        let isValidPassword = txtPassword.isValid && isAlphanumericPassword && isSpecialCharacterPassword
        
        txtConfirmPassword.isValid = (txtConfirmPassword.text == txtPassword.text) && !txtPassword.text.isEmpty

        return isValidPassword && txtConfirmPassword.isValid
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tapTerms() {
        if let url = URL(string: GeneralSessionManager.shared.getLink(key: Constants.keyLinkRecovery)) {
            UIApplication.shared.open(url)
        }
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
