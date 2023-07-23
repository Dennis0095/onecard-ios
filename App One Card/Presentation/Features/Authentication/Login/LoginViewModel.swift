//
//  LoginViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

//typealias LoginValidationActionHandler = ((LoginValidation) -> Void)

import Foundation

protocol LoginViewModelProtocol {
    var username: String { get set }
    var password: String { get set }
    var delegate: LoginViewModelDelegate? { get set }
    
    func toRegister()
    func toHome()
    func toActivateUser()
    func login()
}

protocol LoginViewModelDelegate: LoaderDisplaying {
    func successLogin()
    func toActivateUser()
}

class LoginViewModel: LoginViewModelProtocol {
    var delegate: LoginViewModelDelegate?
    var router: AuthenticationRouterDelegate
    var username: String = ""
    var password: String = ""
    
    private let userUseCase: UserUseCase
    private let cardUseCase: CardUseCase
    
    init(router: AuthenticationRouterDelegate, userUseCase: UserUseCase, cardUseCase: CardUseCase) {
        self.router = router
        self.userUseCase = userUseCase
        self.cardUseCase = cardUseCase
    }
    
    func toRegister() {
        router.navigateToRegister()
    }
    
    func toHome() {
        router.navigateToHome()
    }
    
    func toActivateUser() {
        router.navigateToActivateUser()
    }
    
    func login() {
        if self.username.isEmpty || self.password.isEmpty {
            delegate?.showError(title: Constants.error, description: Constants.login_error_incomplete_data, onAccept: nil)
        } else {
            delegate?.showLoader()
            let request = LoginRequest(user: username, password: password)
            userUseCase.login(request: request) { result in
                self.delegate?.hideLoader {
                    switch result {
                    case .success(let response):
                        if response.success == "1" {
                            self.delegate?.toActivateUser()
                        } else {
                            self.delegate?.showError(title: response.title ?? "", description: response.message ?? "", onAccept: nil)
                        }
                    case .failure(let error):
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            }
        }
    }
}

enum StatusCard {
    case P
    case A
    case X
    case C
}
