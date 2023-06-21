//
//  AuthenticationRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import Foundation

protocol AuthenticationRouterDelegate: Router {
    func navigateToHome()
    func navigateToLogin()
    func navigateToActivateUser()
    func navigateToRegister()
    func navigateToPersonalData()
    //func navigateToVerify()
    func navigateToLoginInformation()
    //func successfulRegistration(title: String, description: String, accept: VoidActionHandler?)
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping VoidActionHandler)
    func showDateList(selected: Date?, action: @escaping SelectDateActionHandler, presented: @escaping VoidActionHandler)
}
