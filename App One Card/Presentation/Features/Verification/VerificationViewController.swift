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
    
    private var viewModel: VerificationViewModelProtocol
    private var number: String
    private var email: String
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
    
    init(viewModel: VerificationViewModelProtocol, navTitle: String, step: String? = nil, titleDescription: String? = nil, number: String, email: String, buttonTitle: String) {
        self.viewModel = viewModel
        self.titleDescription = titleDescription
        self.navTitle = navTitle
        self.step = step
        self.number = number
        self.email = email
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        configure()
        setCount()
        txtCode.configure()
        btnNext.configure(text: buttonTitle, status: .enabled)
        sendToNumber = true
        sendOTP()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        txtCode.didEnterDigits = { [weak self] code in
            self?.viewModel.code = code.count == 4 ? code : nil
        }
    }
    
    private func initTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,   selector: (#selector(self.timerAction)), userInfo: nil, repeats: true)
    }
    
    private func changeSendCodeTitle() {
        btnSendCode.setTitle(sendToNumber ? "Enviar al correo" : "Enviar al celular", for: .normal)
    }
    
    private func setDescription() {
        let maskedPhoneNumber = number.maskPhoneNumber(lastVisibleDigitsCount: 3)
        let maskedEmail = email.maskEmailFirstCharacters()
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
        viewModel.sendOTP(toNumber: sendToNumber, number: number, email: email)
        resetTime()
    }
    
    @IBAction func resend(_ sender: Any) {
        sendOTP()
    }
    
    @IBAction func next(_ sender: Any) {
        if txtCode.validateIsValid() {
            viewModel.validateOTP()
        }
    }
    
    @IBAction func send(_ sender: Any) {
        sendToNumber = !sendToNumber
        sendOTP()
    }
}
