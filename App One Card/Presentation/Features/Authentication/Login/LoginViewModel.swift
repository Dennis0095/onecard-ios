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
    
    func toRegister()
    func toHome()
    func toActivateUser()
    func showError()
    func formValidation()
}

class LoginViewModel: LoginViewModelProtocol {
    var router: AuthenticationRouterDelegate
    var username: String = ""
    var password: String = ""
    
    init(router: AuthenticationRouterDelegate) {
        self.router = router
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
    
    func showError() {
        router.showMessageError()
    }
    
    func formValidation() {
        Loading.shared.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            Loading.shared.hide()
            if self.username.isEmpty || self.password.isEmpty {
                self.router.showMessageError()
            } else {
                self.router.navigateToHome()
            }
        }
    }
}

//enum LoginValidation {
//    case empty
//    case valid
//}
