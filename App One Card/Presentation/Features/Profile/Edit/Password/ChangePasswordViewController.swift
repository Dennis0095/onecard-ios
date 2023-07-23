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
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
    }
    
    @objc private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
