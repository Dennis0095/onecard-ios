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
    func lock()
}

protocol CardLockViewModelDelegate: LoaderDisplaying {
    func successSendOtp()
    func failureSendOtp(error: APIError)
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
    private let successfulRouter: SuccessfulRouterDelegate
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: Router, successfulRouter: SuccessfulRouterDelegate, otpUseCase: OTPUseCase, cardUseCase: CardUseCase) {
        self.router = router
        self.otpUseCase = otpUseCase
        self.cardUseCase = cardUseCase
        self.successfulRouter = successfulRouter
    }
    
    func sendOTPToUpdate(toNumber: Bool) {
        delegate?.showLoader()
        
        let authTrackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        
        let request = SendOTPUpdateRequest(otpShippingType: toNumber ? Constants.OTP_SHIPPING_SMS : Constants.OTP_SHIPPING_EMAIL,
                                           operationType: "BP", authTrackingCode: authTrackingCode)
        
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
                        if !self.wasShownViewCardLock {
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
                    self.wasShownViewCardLock = true
                    self.otpId = response.otpId
                    
                    self.number = response.truncatedCellphone ?? ""
                    self.email = response.truncatedEmail ?? ""
                    
                    self.delegate?.successSendOtp()
                } else {
                    if !self.wasShownViewCardLock {
                        self.delegate?.failureSendOtp(error: apiError)
                    } else {
                        self.delegate?.showError(title: title, description: description, onAccept: nil)
                    }
                }
            }
        
        cancellable.store(in: &cancellables)
    }

    func lock() {        
        guard let otp = self.otpId, let code = self.code else {
            return
        }
        
        delegate?.showLoader()
        
        let authTrackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        let trackingCode = UserSessionManager.shared.getUser()?.cardTrackingCode ?? ""
        
        let request = PrepaidCardLockRequest(otpId: otp, otpCode: code, authTrackingCode: authTrackingCode, trackingCode: trackingCode, reason: "CA")
        
        let cancellable = cardUseCase.prepaidCardLock(request: request)
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
                let error = APIError.defaultError.error()
                
                self.delegate?.hideLoader()
                if response.otpMatchIndex == "1" {
                    CardObserver.shared.updateStatus(status: .CANCEL)
                    self.successfulRouter.navigateToSuccessfulScreen(title: "Tu tarjeta fue bloqueada", description: "Recuerda que para solicitar la reposición de tu tarjeta debes enviar un correo a reposiciones@onecard.pe", button: "Regresar", image: #imageLiteral(resourceName: "card_lock_successfully.svg"), accept: {
                        self.router.backToHome()
                    })
                } else {
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            }
        cancellable.store(in: &cancellables)
    }

}
