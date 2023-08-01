//
//  LoginInformationViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 9/06/23.
//

import Foundation
import Combine

protocol LoginInformationViewModelProtocol {
    var username: String? { get set }
    var password: String? { get set }
    var passwordOk: String? { get set }
    var delegate: LoginInformationViewModelDelegate? { get set }
    
    func registerUser()
    func navigateToSuccessfulScreen()
    func timeExpiredRegister()
}

protocol LoginInformationViewModelDelegate: LoaderDisplaying {
    func successRegister()
    func timeExpired()
}

class LoginInformationViewModel: LoginInformationViewModelProtocol {
    var username: String?
    var password: String?
    var passwordOk: String?
    var delegate: LoginInformationViewModelDelegate?
    
    private let router: AuthenticationRouterDelegate
    private let successfulRouter: SuccessfulRouterDelegate
    private let userUseCase: UserUseCase
    
    private let otpId: String
    private let documentType: String
    private let documentNumber: String
    private let companyRUC: String
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: AuthenticationRouterDelegate, successfulRouter: SuccessfulRouterDelegate, userUseCase: UserUseCase, otpId: String, documentType: String, documentNumber: String, companyRUC: String) {
        self.router = router
        self.successfulRouter = successfulRouter
        self.userUseCase = userUseCase
        self.otpId = otpId
        self.documentType = documentType
        self.documentNumber = documentNumber
        self.companyRUC = companyRUC
    }
    
    deinit {
        cancelRequests()
    }
    
    func navigateToSuccessfulScreen() {
        self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: Constants.congratulations_description, button: Constants.login_btn) {
            self.router.navigateToLogin()
        }
    }
    
    func timeExpiredRegister() {
        self.router.timeExpiredRegister()
    }

    func registerUser() {
        guard let username = self.username, let password = self.password, let passwordOk = self.passwordOk else {
            return
        }
        
        let request = UserRegisterRequest(otpId: otpId, documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC, username: username, password: password, password_ok: passwordOk)
        
        let cancellable = userUseCase.userRegister(request: request)
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
                    if response.validExpiration == "1" {
                        if response.success == "1" {
                            if response.validUser == "1" && response.validPassword == "1" {
                                self.delegate?.successRegister()
                            } else {
                                if response.confirmPassword == "1" {
                                    if response.userExists == "0" {
                                        self.delegate?.successRegister()
                                    } else {
                                        self.delegate?.showError(title: title, description: description, onAccept: nil)
                                    }
                                } else {
                                    self.delegate?.showError(title: title, description: description, onAccept: nil)
                                }
                            }
                        } else {
                            self.delegate?.showError(title: title, description: description, onAccept: nil)
                        }
                    } else {
                        self.delegate?.showError(title: title, description: description) {
                            self.delegate?.timeExpired()
                        }
                    }
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
