//
//  LoginViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import Foundation

protocol LoginViewModelProtocol {
    func toRegister()
    func toHome()
}

class LoginViewModel: LoginViewModelProtocol {
    var router: AuthenticationRouterDelegate
    
    init(router: AuthenticationRouterDelegate) {
        self.router = router
    }
    
    func toRegister() {
        router.navigateToRegister()
    }
    
    func toHome() {
        router.navigateToHome()
    }
}
