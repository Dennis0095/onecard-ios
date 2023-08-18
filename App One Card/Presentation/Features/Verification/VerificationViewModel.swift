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
    var documentType: String { get set }
    var documentNumber: String { get set }
    var companyRUC: String { get set }
    var email: String { get set }
    var number: String { get set }
    var operationType: String { get set }
    var maskPhoneEmail: Bool { get set }
    var wasShownViewVerification: Bool { get set }
    
    func sendOTPToRegister(toNumber: Bool)
    func sendOTPToUpdate(toNumber: Bool)
    func validateOTPToRegister()
    func validateOTPToUpdate()
}

protocol VerificationViewModelDelegate: LoaderDisplaying {
    func successSendOtp()
    func failureSendOtp()
}

class VerificationViewModel: VerificationViewModelProtocol {
    var otpId: String?
    var code: String?
    var documentType: String
    var documentNumber: String
    var companyRUC: String
    var wasShownViewVerification: Bool = false
    var email: String
    var number: String
    var operationType: String
    var maskPhoneEmail: Bool
    var success: VerificationActionHandler?
    var delegate: VerificationViewModelDelegate?
    
    private let otpUseCase: OTPUseCase
    private let router: Router
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: Router, otpUseCase: OTPUseCase, documentType: String, documentNumber: String, companyRUC: String, email: String, number: String, operationType: String, maskPhoneEmail: Bool) {
        self.router = router
        self.otpUseCase = otpUseCase
        self.documentType = documentType
        self.documentNumber = documentNumber
        self.companyRUC = companyRUC
        self.operationType = operationType
        self.email = email
        self.number = number
        self.maskPhoneEmail = maskPhoneEmail
    }
    
    func sendOTPToRegister(toNumber: Bool) {
        
        delegate?.showLoader()
        
        let request = SendOTPRegisterRequest(otpShippingType: toNumber ? Constants.OTP_SHIPPING_SMS : Constants.OTP_SHIPPING_EMAIL, operationType: operationType, documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC)
        
        let cancellable = otpUseCase.sendToRegister(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    self.delegate?.hideLoader()
                    if !self.wasShownViewVerification {
                        self.delegate?.failureSendOtp()
                    } else {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            } receiveValue: { response in
                self.wasShownViewVerification = true
                self.delegate?.hideLoader()
                self.otpId = response.otpId
                self.number = response.truncatedCellphone ?? ""
                self.email = response.truncatedEmail ?? ""
                self.delegate?.successSendOtp()
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func sendOTPToUpdate(toNumber: Bool) {
        delegate?.showLoader()
        
        let authTrackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        
        let request = SendOTPUpdateRequest(otpShippingType: toNumber ? Constants.OTP_SHIPPING_SMS : Constants.OTP_SHIPPING_EMAIL, operationType: operationType, authTrackingCode: authTrackingCode)
        
        let cancellable = otpUseCase.sendToUpdate(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    self.delegate?.hideLoader()
                    if !self.wasShownViewVerification {
                        self.delegate?.failureSendOtp()
                    } else {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            } receiveValue: { response in
                self.wasShownViewVerification = true
                self.delegate?.hideLoader()
                self.otpId = response.otpId
                self.delegate?.successSendOtp()
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func validateOTPToRegister() {
        guard let otp = self.otpId, let code = self.code else {
            return
        }
        
        delegate?.showLoader()
        
        let request = ValidateOTPRegisterRequest(otpId: otp, otpCode: code, operationType: operationType, documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC)
        
        let cancellable = otpUseCase.validateToRegister(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    self.delegate?.hideLoader()
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            } receiveValue: { response in
                let title = response.title ?? ""
                let description = response.message ?? ""
                
                self.delegate?.hideLoader()
                if response.indexMatchOTP == "1" {
                    if let action = self.success {
                        action(otp)
                    }
                } else {
                    self.delegate?.showError(title: title, description: description, onAccept: nil)
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
        
        let request = ValidateOTPUpdateRequest(otpId: otp, otpCode: code, operationType: operationType, authTrackingCode: authTrackingCode)
        
        let cancellable = otpUseCase.validateToUpdate(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    self.delegate?.hideLoader()
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            } receiveValue: { response in
                let title = response.title ?? ""
                let description = response.message ?? ""
                
                self.delegate?.hideLoader()
                if response.indexMatchOTP == "1" {
                    if let action = self.success {
                        action(otp)
                    }
                } else {
                    self.delegate?.showError(title: title, description: description, onAccept: nil)
                }
            }
        
        cancellable.store(in: &cancellables)
    }
}
