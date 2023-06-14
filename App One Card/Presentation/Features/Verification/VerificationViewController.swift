//
//  VerificationViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import UIKit

class VerificationViewController: BaseViewController {

    @IBOutlet weak var txtCode: CodeVerificationTextField!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnNext: PrimaryFilledButton!
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    
    private var viewModel: VerificationViewModelProtocol
    private var number: String
    private var navTitle: String
    private var step: String
    private var timer: Timer?
    
    private var countTimer: Int = 60 {
        didSet {
            setCountLabel()
        }
    }
    
    init(viewModel: VerificationViewModelProtocol, navTitle: String, step: String, number: String) {
        self.viewModel = viewModel
        self.navTitle = navTitle
        self.step = step
        self.number = number
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initView() {
        configure()
        initTimer()
        setNumberLabel()
        setCountLabel()
        txtCode.configure()
        btnNext.configure(text: Constants.next_btn, status: .enabled)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       if self.timer != nil {
          self.timer?.invalidate()
          self.timer = nil
       }
    }
    
    override func setActions() {
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapBack)
        
        txtCode.didEnterLastDigit = { [weak self] code in
            
        }
    }
    
    private func initTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: .common)
            self.timer?.fire()
        }
    }
    
    private func setNumberLabel() {
        let numberString = "\(number)."
        let longString = "Ingrese el código que le hemos enviado al número " + numberString
        let longestWordRange = (longString as NSString).range(of: numberString)

        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "Gotham-Book", size: 14)!])

        attributedString.setAttributes([NSAttributedString.Key.font: UIFont(name: "Gotham-Medium", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor(hexString: "#4A4A4A")], range: longestWordRange)
        lblNumber.attributedText = attributedString
    }
    
    private func setCountLabel() {
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
    }
    
    @objc
    private func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func timerAction() {
        countTimer-=1
        
        if countTimer == 0 {
            timer?.invalidate()
            lblCount.isHidden = true
            btnResend.isHidden = false
        }
    }
    
    @IBAction func resend(_ sender: Any) {
        countTimer = 60
        initTimer()
        lblCount.isHidden = false
        btnResend.isHidden = true
    }
    
    @IBAction func next(_ sender: Any) {
        viewModel.successVerification()
    }
}
