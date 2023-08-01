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
    var email: String? { get set }
    var number: String? { get set }
    var wasShownViewCardLock: Bool { get set }
    
    func sendOTPToUpdate(toNumber: Bool)
    func validateOTPToUpdate()
}

protocol CardLockViewModelDelegate: LoaderDisplaying {
    func successSendOtp()
    func failureSendOtp()
}

class CardLockViewModel: CardLockViewModelProtocol {
    var otpId: String?
    var code: String?
    var trackingCodeAuth: String?
    var wasShownViewCardLock: Bool = false
    var email: String?
    var number: String?
    var success: CardLockActionHandler?
    var delegate: CardLockViewModelDelegate?
    
    private let otpUseCase: OTPUseCase
    private let cardUseCase: CardUseCase
    private let router: Router
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: Router, otpUseCase: OTPUseCase, cardUseCase: CardUseCase) {
        self.router = router
        self.otpUseCase = otpUseCase
        self.cardUseCase = cardUseCase
    }
    
    func sendOTPToUpdate(toNumber: Bool) {
        delegate?.showLoader()
        
        let authTrackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        
        let request = SendOTPUpdateRequest(otpShippingType: toNumber ? Constants.OTP_SHIPPING_SMS : Constants.OTP_SHIPPING_EMAIL, operationType: "AE", authTrackingCode: authTrackingCode)
        
        let cancellable = otpUseCase.sendToUpdate(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    self.delegate?.hideLoader {
                        if !self.wasShownViewCardLock {
                            self.delegate?.failureSendOtp()
                        } else {
                            self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                        }
                    }
                }
            } receiveValue: { response in
                self.wasShownViewCardLock = true
                self.delegate?.hideLoader {
                    self.otpId = response.otpId
                    self.delegate?.successSendOtp()
                }
            }
        
        cancellable.store(in: &cancellables)
    }

    func validateOTPToUpdate() {
        guard let otp = self.otpId, let code = self.code else {
            return
        }
        
        delegate?.showLoader()
        
        let authTrackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        
        let request = ValidateOTPUpdateRequest(otpId: otp, otpCode: code, operationType: "AE", authTrackingCode: authTrackingCode)
        
        let cancellable = otpUseCase.validateToUpdate(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
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
