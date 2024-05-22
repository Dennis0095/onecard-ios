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
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var btnSendCode: UIButton!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var viewCardLock: UIView!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblTitleError: UILabel!
    @IBOutlet weak var lblMessageError: UILabel!
    @IBOutlet weak var btnRetry: PrimaryFilledButton!
    
    private var viewModel: CardLockViewModelProtocol
    private var navTitle: String
    private var buttonTitle: String
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
    
    init(viewModel: CardLockViewModelProtocol, navTitle: String, buttonTitle: String) {
        self.viewModel = viewModel
        self.navTitle = navTitle
        self.buttonTitle = buttonTitle
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
        btnRetry.configure(text: Constants.try_again, status: .enabled)
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
        let maskedPhoneNumber = self.viewModel.number ?? ""
        let maskedEmail = self.viewModel.email ?? ""
        let string = sendToNumber ? " \(maskedPhoneNumber)." : " \(maskedEmail)"
        let longString = "Ingresa el código que te hemos enviado al \(sendToNumber ? "número" : "correo")"  + string
        let longestWordRange = (longString as NSString).range(of: string)

        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "ProximaNova-Medium", size: 14)!])

        attributedString.setAttributes([NSAttributedString.Key.font: UIFont(name: "ProximaNova-Bold", size: 14)!], range: longestWordRange)
        lblDescription.attributedText = attributedString
    }
    
    private func setCount() {
        let countString = "\(countTimer) seg."
        let longString = "Podrás solicitar un nuevo código en " + countString
        let longestWordRange = (longString as NSString).range(of: countString)

        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "Gotham-Light", size: 14)!])

        attributedString.setAttributes([NSAttributedString.Key.font: UIFont(name: "ProximaNova-Bold", size: 14)!], range: longestWordRange)
        lblCount.attributedText = attributedString
    }

    private func configure() {
        lblNavTitle.text = navTitle
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
        viewModel.sendOTPToUpdate(toNumber: sendToNumber)
    }
    
    @IBAction func resend(_ sender: Any) {
        sendOTP()
    }
    
    @IBAction func next(_ sender: Any) {
        if txtCode.validateIsValid() {
            viewModel.lock()
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
        DispatchQueue.main.async {
            self.setDescription()
            
            self.viewCardLock.isHidden = false
            self.viewError.isHidden = true
            self.resetTime()
        }
    }
    
    func failureSendOtp(error: APIError) {
        DispatchQueue.main.async {
            self.lblTitleError.text = error.error().title
            self.lblMessageError.text = error.error().description
            
            switch error {
            case .networkError:
                self.imgError.image = #imageLiteral(resourceName: "connection_error_blue.svg")
            default:
                self.imgError.image = #imageLiteral(resourceName: "something_went_wrong_blue.svg")
            }
            
            self.viewError.isHidden = false
            self.viewCardLock.isHidden = true
        }
    }
}
