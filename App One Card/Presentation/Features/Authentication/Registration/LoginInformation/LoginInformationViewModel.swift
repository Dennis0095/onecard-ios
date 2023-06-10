//
//  LoginInformationViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 9/06/23.
//

import Foundation

protocol LoginInformationViewModelProtocol {
    func successfulRegister(accept: VoidActionHandler?)
    func toLogin()
}

class LoginInformationViewModel: LoginInformationViewModelProtocol {
    var router: AuthenticationRouterDelegate?
    
    func successfulRegister(accept: VoidActionHandler?) {
        router?.successfulRegistration(title: Constants.congratulations, description: Constants.congratulations_description, accept: accept)
    }
    
    func toLogin() {
        router?.navigateToLogin()
    }
}
