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
    @IBOutlet weak var lblForgot: UILabel!
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
        txtUser.configure(placeholder: Constants.placeholder_digital_user, status: .activated)
        txtPassword.configure(placeholder: Constants.placeholder_password, status: .activated, isPassword: true)
        btnLogin.configure(text: Constants.login_btn, status: .enabled)
        btnRegister.configure(text: Constants.login_register_btn)
        
        connectFields(textFields: txtUser.txt, txtPassword.txt)
        ui()
        addGestures()
        
        viewModel.onAppear()
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
    }
    
    //MARK: Funcs
    
    private func addGestures() {
        let tapForgot = UITapGestureRecognizer(target: self, action: #selector(actionForgot))
        lblForgot.isUserInteractionEnabled = true
        lblForgot.addGestureRecognizer(tapForgot)
    }
    
    private func ui() {
        let userString = "usuario"
        let keyString = "clave digital"
        let longString = "Olvidé mi usuario o clave digital"
        let firstLongestWordRange = (longString as NSString).range(of: userString)
        let secondLongestWordRange = (longString as NSString).range(of: keyString)

        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "ProximaNova-Medium", size: 14)!])

        attributedString.setAttributes([NSAttributedString.Key.font: UIFont(name: "ProximaNova-Bold", size: 14)!, NSAttributedString.Key.foregroundColor: Design.color(.blue_sky)], range: firstLongestWordRange)
        attributedString.setAttributes([NSAttributedString.Key.font: UIFont(name: "ProximaNova-Bold", size: 14)!, NSAttributedString.Key.foregroundColor: Design.color(.blue_sky)], range: secondLongestWordRange)
        lblForgot.attributedText = attributedString
    }
    
    @objc func actionForgot(gesture: UITapGestureRecognizer) {
        let text = "Olvidé mi usuario o clave digital"
        let userString = (text as NSString).range(of: "usuario")
        let keyString = (text as NSString).range(of: "clave digital")
        
        if gesture.didTapAttributedTextInLabel(label: lblForgot, inRange: userString) {
            viewModel.toForgotUser()
        } else if gesture.didTapAttributedTextInLabel(label: lblForgot, inRange: keyString) {
            viewModel.toForgotPassword()
        }
    }
    
    //MARK: IBActions
    
    @IBAction func login(_ sender: Any) {
        viewModel.login()
    }
    
    @IBAction func register(_ sender: Any) {
        viewModel.toRegister()
    }
    
}

extension LoginViewController: LoginViewModelDelegate { }
