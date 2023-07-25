//
//  CardLockViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import UIKit

typealias CardLockActionHandler = ((String) -> Void)

class CardLockViewController: BaseViewController {

    @IBOutlet weak var txtCode: CodeVerificationTextField!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblTitleDescription: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var btnSendCode: UIButton!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var viewCardLock: UIView!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblTitleError: UILabel!
    @IBOutlet weak var lblMessageError: UILabel!
    @IBOutlet weak var btnRetry: PrimaryFilledButton!
    
    private var viewModel: CardLockViewModelProtocol
    private var number: String
    private var email: String
    private var titleDescription: String?
    private var navTitle: String
    private var buttonTitle: String
    private var maskPhoneEmail: Bool
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
    
    init(viewModel: CardLockViewModelProtocol, navTitle: String, titleDescription: String? = nil, number: String, email: String, buttonTitle: String, maskPhoneEmail: Bool = false) {
        self.viewModel = viewModel
        self.titleDescription = titleDescription
        self.navTitle = navTitle
        self.number = number
        self.email = email
        self.buttonTitle = buttonTitle
        self.maskPhoneEmail = maskPhoneEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        viewError.isHidden = true
        viewCardLock.isHidden = true
        
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
        var outputString = ""

        for (index, character) in number.enumerated() {
            if index > 0 && index % 3 == 0 {
                outputString += " "
            }
            outputString.append(character)
        }
        
        let maskedPhoneNumber = maskPhoneEmail ? number.maskPhoneNumber(lastVisibleDigitsCount: 3) : outputString
        let maskedEmail = maskPhoneEmail ? email.maskEmailFirstCharacters() : email
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
        
        lblTitleDescription.isHidden = titleDescription == nil
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
        //resetTime()
    }
    
    @IBAction func resend(_ sender: Any) {
        sendOTP()
    }
    
    @IBAction func next(_ sender: Any) {
        if txtCode.validateIsValid() {
            viewModel.cardLock()
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

extension CardLockViewController: CardLockViewModelDelegate {
    func successSendOtp() {
        viewCardLock.isHidden = false
        viewError.isHidden = true
        resetTime()
    }
    
    func failureSendOtp() {
        viewError.isHidden = false
        viewCardLock.isHidden = true
    }
}