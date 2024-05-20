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
    
    func sendOTP(toNumber: Bool)
    func sendOTPToUpdate(toNumber: Bool)
    func validateOTP()
    func validateOTPToUpdate()
}

protocol VerificationViewModelDelegate: LoaderDisplaying {
    func successSendOtp()
    func failureSendOtp(error: APIError)
    func failureRecoverUser(error: APIError)
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
    private let userUseCase: UserUseCase
    private let router: Router
    private let successfulRouter: SuccessfulRouterDelegate
    private let authRouter: AuthenticationRouterDelegate
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: Router, successfulRouter: SuccessfulRouterDelegate, authRouter: AuthenticationRouterDelegate, otpUseCase: OTPUseCase, userUseCase: UserUseCase, documentType: String, documentNumber: String, companyRUC: String, email: String, number: String, operationType: String, maskPhoneEmail: Bool) {
        self.router = router
        self.successfulRouter = successfulRouter
        self.authRouter = authRouter
        self.otpUseCase = otpUseCase
        self.documentType = documentType
        self.documentNumber = documentNumber
        self.companyRUC = companyRUC
        self.operationType = operationType
        self.email = email
        self.number = number
        self.maskPhoneEmail = maskPhoneEmail
        self.userUseCase = userUseCase
    }
    
    private func userRecovery(otpId: String, documentType: String, documentNumber: String, companyRUC: String) {
        delegate?.showLoader()
        
        let request = UserRecoveryRequest(otpId: otpId,
                                          documentType: documentType,
                                          documentNumber: documentNumber,
                                          companyRUC: companyRUC)
        
        let cancellable = userUseCase.userRecovery(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    self.delegate?.hideLoader()
                    self.delegate?.failureRecoverUser(error: apiError)
                }
            } receiveValue: { response in
                self.delegate?.hideLoader()
                
                let title = response.title ?? ""
                let description = response.message ?? ""
                let apiError = APIError.custom(title, description)
                
                if response.success == "1" {
                    self.successfulRouter.navigateToSuccessfulScreen(title: "Tu usuario digital es:", description: response.userName ?? "", button: "Ingresar", image: #imageLiteral(resourceName: "user_recovery_successfully.svg")) {
                        self.authRouter.navigateToLogin()
                    }
                } else {
                    self.delegate?.failureRecoverUser(error: apiError)
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func sendOTP(toNumber: Bool) {
        
        delegate?.showLoader()
        
        let request = SendOTPRequest(otpShippingType: Constants.OTP_SHIPPING_EMAIL,
                                     operationType: operationType,
                                     documentType: documentType, 
                                     documentNumber: documentNumber,
                                     companyRUC: companyRUC)
        
        let cancellable = otpUseCase.send(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    if !self.wasShownViewVerification {
                        self.delegate?.failureSendOtp(error: apiError)
                    } else {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            } receiveValue: { response in
                self.delegate?.hideLoader()
                
                let title = response.title ?? ""
                let description = response.message ?? ""
                let apiError = APIError.custom(title, description)
                
                if response.success == "1" {
                    self.wasShownViewVerification = true
                    self.otpId = response.otpId
                    
                    if self.maskPhoneEmail {
                        self.number = response.truncatedCellphone ?? ""
                        self.email = response.truncatedEmail ?? ""
                    }
                    
                    self.delegate?.successSendOtp()
                } else {
                    if !self.wasShownViewVerification {
                        self.delegate?.failureSendOtp(error: apiError)
                    } else {
                        self.delegate?.showError(title: title, description: description, onAccept: nil)
                    }
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func sendOTPToUpdate(toNumber: Bool) {
        delegate?.showLoader()
        
        let authTrackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        
        let request = SendOTPUpdateRequest(otpShippingType: Constants.OTP_SHIPPING_EMAIL,
                                           operationType: operationType, 
                                           authTrackingCode: authTrackingCode)
        
        let cancellable = otpUseCase.sendToUpdate(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    switch apiError {
                    case .expiredSession:
                        self.delegate?.showError(title: error.title, description: error.description) {
                            self.router.logout(isManual: false)
                        }
                    default:
                        if !self.wasShownViewVerification {
                            self.delegate?.failureSendOtp(error: apiError)
                        } else {
                            self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                        }
                    }
                }
            } receiveValue: { response in
                self.delegate?.hideLoader()
                
                let title = response.title ?? ""
                let description = response.message ?? ""
                let apiError = APIError.custom(title, description)
                
                if response.success == "1" {
                    self.wasShownViewVerification = true
                    
                    self.otpId = response.otpId
                    self.number = response.truncatedCellphone ?? ""
                    self.email = response.truncatedEmail ?? ""
                    self.delegate?.successSendOtp()
                } else {
                    if !self.wasShownViewVerification {
                        self.delegate?.failureSendOtp(error: apiError)
                    } else {
                        self.delegate?.showError(title: title, description: description, onAccept: nil)
                    }
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func validateOTP() {
        guard let otp = self.otpId, let code = self.code else {
            return
        }
        
        delegate?.showLoader()
        
        let request = ValidateOTPRegisterRequest(otpId: otp, otpCode: code, operationType: operationType, documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC)
        
        let cancellable = otpUseCase.validateToRegister(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            } receiveValue: { [weak self] response in
                let title = response.title ?? ""
                let description = response.message ?? ""
                
                self?.delegate?.hideLoader()
                if response.indexMatchOTP == "1" {
                    if self?.operationType == Constants.user_recovery_operation_type {
                        self?.userRecovery(otpId: otp,
                                           documentType: self?.documentType ?? "",
                                           documentNumber: self?.documentNumber ?? "",
                                          companyRUC: self?.companyRUC ?? "")
                    } else {
                        if let action = self?.success {
                            action(otp)
                        }
                    }
                } else {
                    self?.delegate?.showError(title: title, description: description, onAccept: nil)
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
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.delegate?.showError(title: error.title, description: error.description) {
                        switch apiError {
                        case .expiredSession:
                            self.router.logout(isManual: false)
                        default: break
                        }
                    }
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
