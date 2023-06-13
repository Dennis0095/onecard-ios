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
    var router: AuthenticationRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    
    init(router: AuthenticationRouterDelegate, successfulRouter: SuccessfulRouterDelegate) {
        self.router = router
        self.successfulRouter = successfulRouter
    }
    
    func successfulRegister(accept: VoidActionHandler?) {
        successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: Constants.congratulations_description, button: Constants.enter, accept: accept)
    }
    
    func toLogin() {
        router.navigateToLogin()
    }
}
