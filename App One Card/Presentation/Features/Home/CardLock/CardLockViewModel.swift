//
//  CardLockViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import Foundation
import Combine

protocol CardLockViewModelProtocol {
    var otpId: String? { get set }
    var code: String? { get set }
    var trackingCodeAuth: String? { get set }
    var wasShownViewCardLock: Bool { get set }
    
    func sendOTP(toNumber: Bool, number: String, email: String)
    func cardLock()
}

protocol CardLockViewModelDelegate: LoaderDisplaying {
    func successSendOtp()
    func failureSendOtp()
}

class CardLockViewModel: CardLockViewModelProtocol {
    var otpId: String?
    var code: String?
    var trackingCodeAuth: String?
    var success: CardLockActionHandler?
    var delegate: CardLockViewModelDelegate?
    var wasShownViewCardLock: Bool = false
    
    private let otpUseCase: OTPUseCase
    private let cardUseCase: CardUseCase
    private let router: Router
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: Router, otpUseCase: OTPUseCase, cardUseCase: CardUseCase) {
        self.router = router
        self.otpUseCase = otpUseCase
        self.cardUseCase = cardUseCase
    }
    
    func sendOTP(toNumber: Bool, number: String, email: String) {
        delegate?.showLoader()
        
        let request = SendOTPRequest(otpShippingType: toNumber ? Constants.OTP_SHIPPING_SMS : Constants.OTP_SHIPPING_EMAIL, cellPhone: number, email: email)
        
//        otpUseCase.send(request: request) { result in
//            self.delegate?.hideLoader {
//                switch result {
//                case .success(let response):
//                    self.otpId = response.otpId
//                    self.delegate?.successSendOtp()
//                case .failure(let error):
//                    if !self.wasShownViewCardLock {
//                        self.delegate?.failureSendOtp()
//                    } else {
//                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
//                    }
//                }
//            }
//        }
        let cancellable = otpUseCase.send(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    let error = CustomError(title: "Error", description: error.localizedDescription)
                    self.delegate?.hideLoader {
                        if !self.wasShownViewCardLock {
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
    
    func cardLock() {
        guard let otp = self.otpId, let code = self.code, let trackingCodeAuth = self.trackingCodeAuth else {
            return
        }
        
//        delegate?.showLoader()
//        
//        let request = ValidateOTPRequest(otpId: otp, otpCode: code)
//        otpUseCase.validate(request: request) { result in
//            self.delegate?.hideLoader {
//                switch result {
//                case .success(_):
//                    if let action = self.success {
//                        action(otp)
//                    }
//                case .failure(let error):
//                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
//                }
//            }
//        }
    }
}
