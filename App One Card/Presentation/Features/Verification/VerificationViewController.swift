//
//  VerificationViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import UIKit

typealias VerificationActionHandler = ((String) -> Void)

class VerificationViewController: BaseViewController {

    @IBOutlet weak var txtCode: CodeVerificationTextField!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblTitleDescription: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var viewStep: UIView!
    @IBOutlet weak var btnSendCode: UIButton!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var viewVerification: UIView!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblTitleError: UILabel!
    @IBOutlet weak var lblMessageError: UILabel!
    @IBOutlet weak var btnRetry: PrimaryFilledButton!
    
    private var viewModel: VerificationViewModelProtocol
    private var titleDescription: String?
    private var navTitle: String
    private var buttonTitle: String
    private var step: String?
    private var timer = Timer()
    
    private var countTimer: Int = 60 {
        didSet {
            setCount()
        }
    }
    
    private var sendToNumber: Bool = true {
        didSet {
            setDescription()
            changeSendCodeTitle()
        }
    }
    
    init(viewModel: VerificationViewModelProtocol, navTitle: String, step: String? = nil, titleDescription: String? = nil, buttonTitle: String) {
        self.viewModel = viewModel
        self.titleDescription = titleDescription
        self.navTitle = navTitle
        self.step = step
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        viewError.isHidden = true
        viewVerification.isHidden = true
        
        configure()
        setCount()
        txtCode.configure()
        btnNext.configure(text: buttonTitle, status: .enabled)
        btnRetry.configure(text: "VOLVER A INTENTAR", status: .enabled)
        sendToNumber = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.sendOTP()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        txtCode.didEnterDigits = { [weak self] code in
            self?.viewModel.code = code.count == 6 ? code : nil
        }
    }
    
    private func initTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,   selector: (#selector(self.timerAction)), userInfo: nil, repeats: true)
    }
    
    private func changeSendCodeTitle() {
        btnSendCode.setTitle(sendToNumber ? "Enviar al correo" : "Enviar al celular", for: .normal)
    }
    
    private func setDescription() {
        var outputString = ""

        if !viewModel.maskPhoneEmail {
            for (index, character) in self.viewModel.number.enumerated() {
                if index > 0 && index % 3 == 0 {
                    outputString += " "
                }
                outputString.append(character)
            }
        }
        
        let maskedPhoneNumber = self.viewModel.maskPhoneEmail ? self.viewModel.number : outputString
        let maskedEmail = self.viewModel.maskPhoneEmail ? self.viewModel.email.maskEmailFirstCharacters() : self.viewModel.email
        let string = sendToNumber ? " \(maskedPhoneNumber)." : " \(maskedEmail)"
        let longString = "Ingrese el código que le hemos enviado al \(sendToNumber ? "número" : "correo")"  + string
        let longestWordRange = (longString as NSString).range(of: string)

        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "Gotham-Book", size: 14)!])

        attributedString.setAttributes([NSAttributedString.Key.font: UIFont(name: "Gotham-Medium", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor(hexString: "#4A4A4A")], range: longestWordRange)
        lblDescription.attributedText = attributedString
    }
    
    private func setCount() {
        let countString = "\(countTimer) seg."
        let longString = "Podrá solicitar un nuevo código en " + countString
        let longestWordRange = (longString as NSString).range(of: countString)

        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "Gotham-Light", size: 14)!])

        attributedString.setAttributes([NSAttributedString.Key.font: UIFont(name: "Gotham-Medium", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor(hexString: "#4A4A4A")], range: longestWordRange)
        lblCount.attributedText = attributedString
    }

    private func configure() {
        lblNavTitle.text = navTitle
        lblStep.text = step
        
        lblTitleDescription.isHidden = titleDescription == nil
        viewStep.isHidden = step == nil
    }
    
    @objc
    private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func timerAction() {
        countTimer-=1
        
        if countTimer == 0 {
            timer.invalidate()
            lblCount.isHidden = true
            btnResend.isHidden = false
        }
    }
    
    private func resetTime() {
        countTimer = 60
        timer.invalidate()
        initTimer()
        lblCount.isHidden = false
        btnResend.isHidden = true
    }
    
    private func sendOTP() {
        if viewModel.operationType == "RU" {
            viewModel.sendOTPToRegister(toNumber: sendToNumber)
        } else {
            viewModel.sendOTPToUpdate(toNumber: sendToNumber)
        }
    }
    
    @IBAction func resend(_ sender: Any) {
        sendOTP()
    }
    
    @IBAction func next(_ sender: Any) {
        if txtCode.validateIsValid() {
            if viewModel.operationType == "RU" {
                viewModel.validateOTPToRegister()
            } else {
                viewModel.validateOTPToUpdate()
            }
        }
    }
    
    @IBAction func send(_ sender: Any) {
        sendToNumber = !sendToNumber
        sendOTP()
    }
    
    @IBAction func tryAgain(_ sender: Any) {
        sendOTP()
    }
}

extension VerificationViewController: VerificationViewModelDelegate {
    func successSendOtp() {
        viewVerification.isHidden = false
        viewError.isHidden = true
        resetTime()
    }
    
    func failureSendOtp() {
        viewError.isHidden = false
        viewVerification.isHidden = true
    }
}
