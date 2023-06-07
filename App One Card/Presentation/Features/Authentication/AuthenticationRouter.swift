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
    func navigateToRegister()
    func navigateToPersonalData()
    func navigateToVerify()
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping DismissActionHandler)
    func showDateList(selected: Date?, action: @escaping SelectDateActionHandler, presented: @escaping DismissActionHandler)
}
