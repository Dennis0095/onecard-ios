//
//  PinViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 22/06/23.
//

import UIKit

typealias PinActionHandler = ((_ operationId: String, _ pin: String) -> Void)

class PinViewController: BaseViewController {

    @IBOutlet weak var txtPin: PinOutlinedTextField!
    @IBOutlet weak var keyboardButtons: KeyboardNumber!
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var viewStep: UIView!
    @IBOutlet weak var lblTitleDescription: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    private var viewModel: PinViewModelProtocol
    private var titleDescription: String?
    private var descriptionOfTitle: String?
    private var navTitle: String
    private var buttonTitle: String
    private var placeholder: String
    private var isConfirmPin: Bool?
    private var step: String?

    init(viewModel: PinViewModelProtocol, navTitle: String, step: String? = nil, titleDescription: String? = nil, description: String? = nil, buttonTitle: String, placeholder: String, isConfirmPin: Bool? = false) {
        self.viewModel = viewModel
        self.titleDescription = titleDescription
        self.navTitle = navTitle
        self.step = step
        self.descriptionOfTitle = description
        self.buttonTitle = buttonTitle
        self.placeholder = placeholder
        self.isConfirmPin = isConfirmPin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        txtPin.configure(placeholder: "", errorMessage: "Debe tener 4 dígitos", status: .activated, isPassword: true)
        btnNext.configure(text: buttonTitle, status: .enabled)
        configure()
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        keyboardButtons.actionButton = { number in
            if self.viewModel.pin.count < 4 {
                self.viewModel.pin.append(number)
                self.txtPin.text = self.viewModel.pin
            }
        }
        
        keyboardButtons.actionClear = {
            if self.viewModel.pin.count > 0 {
                self.viewModel.pin.removeLast()
                self.txtPin.text = self.viewModel.pin
            }
        }
    }
    
    private func configure() {
        lblNavTitle.text = navTitle
        lblStep.text = step
        lblTitleDescription.text = titleDescription
        lblDescription.text = descriptionOfTitle
        txtPin.setPlaceholder(placeholder: placeholder)
        
        lblTitleDescription.isHidden = titleDescription == nil
        lblDescription.isHidden = descriptionOfTitle == nil
        viewStep.isHidden = step == nil
    }
    
    private func validate() -> Bool {
        if viewModel.pinStep == .cardActivation || viewModel.pinStep == .reassign {
            txtPin.errorMessage = txtPin.text.isEmpty ? "Debes ingresar el PIN" : "El PIN no coincide"
            txtPin.isValid = !txtPin.text.isEmpty && viewModel.newPin == txtPin.text
        } else {
            txtPin.errorMessage = txtPin.text.isEmpty ? "Debes ingresar el PIN" : "Debe tener 4 dígitos"
            txtPin.isValid = txtPin.text.count == 4
        }
        
        return txtPin.isValid
    }
    
    @objc
    private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        if validate() {
            viewModel.nextStep()
        }
    }
}

extension PinViewController: PinViewModelDelegate {}
