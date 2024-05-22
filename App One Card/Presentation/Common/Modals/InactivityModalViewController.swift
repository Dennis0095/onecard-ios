//
//  InactivityModalViewController.swift
//  App One Card
//
//  Created by Paolo Arambulo on 16/08/23.
//

import UIKit

class InactivityModalViewController: UIViewController {

    @IBOutlet weak var btnContinue: PrimaryFilledButton!
    @IBOutlet weak var btnCloseSession: PrimaryOutlineButton!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    
    var accept: VoidActionHandler?
    var closeSession: VoidActionHandler?
    
    private var timer = Timer()
    private var countTimer: Int = 40 {
        didSet {
            setCount()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCloseSession.configure(text: Constants.close_session)
        btnContinue.configure(text: Constants.next_btn, status: .enabled)
        
        viewBackground.layer.cornerRadius = 16.0
        viewBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setCount()
        initTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    
    private func setCount() {
        let countString = "\(countTimer) seg."
        let longString = "Por tu seguridad, la sesión se cerrará dentro de " + countString
        let longestWordRange = (longString as NSString).range(of: countString)

        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "ProximaNova-Medium", size: 15)!])

        attributedString.setAttributes([NSAttributedString.Key.font: UIFont(name: "ProximaNova-Bold", size: 15)!], range: longestWordRange)
        lblCount.attributedText = attributedString
    }
    
    private func initTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,   selector: (#selector(self.timerAction)), userInfo: nil, repeats: true)
    }
    
    @objc
    private func timerAction() {
        countTimer-=1
        
        if countTimer == 0 {
            timer.invalidate()
        }
    }
    
    @IBAction func clickContinue(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true) {
            if let completion = self.accept {
                completion()
            }
        }
    }
    
    @IBAction func clickCloseSession(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true) {
            if let completion = self.closeSession {
                completion()
            }
        }
    }
}
