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
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: Router, otpUseCase: OTPUseCase) {
        self.router = router
        self.otpUseCase = otpUseCase
    }
    
    func sendOTP(toNumber: Bool, number: String, email: String) {
        delegate?.showLoader()
        
        let request = SendOTPRequest(otpShippingType: toNumber ? Constants.OTP_SHIPPING_SMS : Constants.OTP_SHIPPING_EMAIL, cellPhone: number, email: email)
        
        let cancellable = otpUseCase.send(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    let error = CustomError(title: "Error", description: error.localizedDescription)
                    self.delegate?.hideLoader {
                        if !self.wasShownViewVerification {
                            self.delegate?.failureSendOtp()
                        } else {
                            self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                        }
                    }
                }
            } receiveValue: { response in
                self.delegate?.hideLoader {
                    self.otpId = response.otpId
                    self.delegate?.successSendOtp()
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func validateOTP() {
        guard let otp = self.otpId, let code = self.code else {
            return
        }
        
        delegate?.showLoader()
        
        let request = ValidateOTPRequest(otpId: otp, otpCode: code)
//        otpUseCase.validate(request: request) { result in
//            self.delegate?.hideLoader {
//                switch result {
//                case .success(_):
////                    DispatchQueue.main.async {
////
////                    }
//                    if let action = self.success {
//                        action(otp)
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        //self.router.showMessageError(title: error.title, description: error.description, completion: nil)
//                    }
//                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
//                }
//            }
//        }
        let cancellable = otpUseCase.validate(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    let error = CustomError(title: "Error", description: error.localizedDescription)
                    self.delegate?.hideLoader {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            } receiveValue: { response in
                let title = response.title ?? ""
                let description = response.message ?? ""
                
                self.delegate?.hideLoader {
                    if response.indexMatchOTP == "1" {
                        if let action = self.success {
                            action(otp)
                        }
                    } else {
                        self.delegate?.showError(title: title, description: description, onAccept: nil)
                    }
                }
            }
        
        cancellable.store(in: &cancellables)
    }
}
