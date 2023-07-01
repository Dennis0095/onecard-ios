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
    
    func sendOTP(toNumber: Bool, number: String, email: String)
    func validateOTP()
}

class VerificationViewModel: VerificationViewModelProtocol {
    var otpId: String?
    var code: String?
    var success: VerificationActionHandler?
    
    private let otpUseCase: OTPUseCase
    private let router: Router
    
    init(router: Router, otpUseCase: OTPUseCase) {
        self.router = router
        self.otpUseCase = otpUseCase
    }
    
    func sendOTP(toNumber: Bool, number: String, email: String) {
        let request = SendOTPRequest(otpShippingType: toNumber ? Constants.OTP_SHIPPING_SMS : Constants.OTP_SHIPPING_EMAIL, cellPhone: number, email: email)
        
        otpUseCase.send(request: request) { result in
            switch result {
            case .success(let response):
                self.otpId = response.otpId
            case .failure(_): break
            }
        }
    }
    
    func validateOTP() {
        guard let otp = self.otpId, let code = self.code else {
            return
        }
        
        let request = ValidateOTPRequest(otpId: otp, otpCode: code)

        otpUseCase.validate(request: request) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    if let action = self.success {
                        action(otp)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.router.showMessageError(title: error.title, description: error.description, completion: nil)
                }
            }
        }
    }
}
