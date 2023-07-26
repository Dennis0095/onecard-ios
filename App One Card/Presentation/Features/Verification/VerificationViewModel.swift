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
    var maskedNumber: String? { get set }
    var maskedEmail: String? { get set }
    var email: String { get set }
    var number: String { get set }
    var wasShownViewVerification: Bool { get set }
    
    func sendOTP(toNumber: Bool)
    func validateOTP()
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
    var maskedNumber: String?
    var maskedEmail: String?
    var email: String
    var number: String
    var success: VerificationActionHandler?
    var delegate: VerificationViewModelDelegate?
    
    private let otpUseCase: OTPUseCase
    private let router: Router
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: Router, otpUseCase: OTPUseCase, documentType: String, documentNumber: String, companyRUC: String, number: String, email: String) {
        self.router = router
        self.otpUseCase = otpUseCase
        self.documentType = documentType
        self.documentNumber = documentNumber
        self.companyRUC = companyRUC
        self.number = number
        self.email = email
    }
    
    func sendOTP(toNumber: Bool) {
        delegate?.showLoader()
        
        //let request = SendOTPRequest(otpShippingType: toNumber ? Constants.OTP_SHIPPING_SMS : Constants.OTP_SHIPPING_EMAIL, cellPhone: number, email: email)
        let request = SendOTPRequest(otpShippingType: toNumber ? Constants.OTP_SHIPPING_SMS : Constants.OTP_SHIPPING_EMAIL, operationType: "RU", documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC)
        
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
                    self.maskedNumber = response.truncatedCellphone
                    self.maskedEmail = response.truncatedEmail
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
        
        //let request = ValidateOTPRequest(otpId: otp, otpCode: code)
        let request = ValidateOTPRequest(otpId: otp, otpCode: code, operationType: "RU", documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC)
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
