//
//  HomeRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/06/23.
//

import Foundation

protocol HomeRouterDelegate: Router {
    func modalCardBlock()
    func navigateToInputPinConfirmation(newPin: String, success: @escaping PinActionHandler)
    func navigateToInputNewPin(success: @escaping PinActionHandler)
    func navigateToInputCurrentPin(success: @escaping PinActionHandler)
    func navigateToCardBlock(email: String, number: String, navTitle: String, success: @escaping VerificationActionHandler)
    func navigateToConfigureCard()
    func successfulCardBlock()
    func successfulConfigureCard()
}
