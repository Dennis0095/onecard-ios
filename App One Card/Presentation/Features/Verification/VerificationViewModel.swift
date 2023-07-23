//
//  VerificationViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 7/06/23.
//

import Foundation
import Combine

protocol VerificationViewModelProtocol {
    var otpId: String? { get set }
    var code: String? { get set }
    var wasShownViewVerification: Bool { get set }
    
    func sendOTP(toNumber: Bool, number: String, email: String)
    func validateOTP()
}

protocol VerificationViewModelDelegate: LoaderDisplaying {
    func successSendOtp()
    func failureSendOtp()
}

class VerificationViewModel: VerificationViewModelProtocol {
    var otpId: String?
    var code: String?
    var success: VerificationActionHandler?
    var delegate: VerificationViewModelDelegate?
    var wasShownViewVerification: Bool = false
    
    private let otpUseCase: OTPUseCase
    private let router: Router
    
    init(router: Router, otpUseCase: OTPUseCase) {
        self.router = router
        self.otpUseCase = otpUseCase
    }
    
    func sendOTP(toNumber: Bool, number: String, email: String) {
        delegate?.showLoader()
        
        let request = SendOTPRequest(otpShippingType: toNumber ? Constants.OTP_SHIPPING_SMS : Constants.OTP_SHIPPING_EMAIL, cellPhone: number, email: email)
        
        otpUseCase.send(request: request) { result in
            self.delegate?.hideLoader {
                switch result {
                case .success(let response):
                    self.otpId = response.otpId
                    if !self.wasShownViewVerification {
                        self.delegate?.successSendOtp()
                    }
                case .failure(let error):
                    if !self.wasShownViewVerification {
                        self.delegate?.failureSendOtp()
                    } else {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            }
        }
    }
    
    func validateOTP() {
        guard let otp = self.otpId, let code = self.code else {
            return
        }
        
        delegate?.showLoader()
        
        let request = ValidateOTPRequest(otpId: otp, otpCode: code)
        otpUseCase.validate(request: request) { result in
            self.delegate?.hideLoader {
                switch result {
                case .success(_):
//                    DispatchQueue.main.async {
//
//                    }
                    if let action = self.success {
                        action(otp)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        //self.router.showMessageError(title: error.title, description: error.description, completion: nil)
                    }
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            }
        }
    }
}
