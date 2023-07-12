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
    func navigateToPersonalData(beforeRequest: ValidateAffiliationRequest)
    //func navigateToPin()
    func navigateToPin(success: @escaping PinActionHandler)
    func navigateToNewPin(success: @escaping PinActionHandler)
    func navigateToConfirmPin(newPin: String, success: @escaping PinActionHandler)
    func timeExpiredRegister()
    func navigateToLoginInformation(otpId: String, documentType: String, documentNumber: String, companyRUC: String)
    //func successfulRegistration(title: String, description: String, accept: VoidActionHandler?)
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping VoidActionHandler)
    func showDateList(selected: Date?, action: @escaping SelectDateActionHandler, presented: @escaping VoidActionHandler)
}
