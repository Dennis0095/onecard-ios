//
//  LoginViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import Foundation

protocol LoginViewModelProtocol {
    func toRegister()
}

class LoginViewModel: LoginViewModelProtocol {
    var router: AuthenticationRouterDelegate?
    
    func toRegister() {
        router?.navigateToRegister()
    }
}
