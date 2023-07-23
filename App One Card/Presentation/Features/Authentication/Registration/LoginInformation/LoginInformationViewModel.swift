//
//  LoginInformationViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 9/06/23.
//

import Foundation

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
    
    init(router: AuthenticationRouterDelegate, successfulRouter: SuccessfulRouterDelegate, userUseCase: UserUseCase, otpId: String, documentType: String, documentNumber: String, companyRUC: String) {
        self.router = router
        self.successfulRouter = successfulRouter
        self.userUseCase = userUseCase
        self.otpId = otpId
        self.documentType = documentType
        self.documentNumber = documentNumber
        self.companyRUC = companyRUC
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
        
        userUseCase.userRegister(request: request) { result in
            switch result {
            case .success(_):
                self.delegate?.successRegister()
            case .failure(let error):
                self.delegate?.showError(title: error.title, description: error.description) {
                    if error.timeExpired {
                        self.delegate?.timeExpired()
                    }
                }
            }
        }
    }
}
