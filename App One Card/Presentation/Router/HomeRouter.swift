//
//  HomeRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/06/23.
//

import Foundation

protocol HomeRouterDelegate: Router {
    func confirmCardLock(accept: VoidActionHandler?)
    func navigateToInputPinConfirmation(newPin: String, success: @escaping PinActionHandler)
    func navigateToInputNewPin(success: @escaping PinActionHandler)
    func navigateToInputCurrentPin(success: @escaping PinActionHandler)
    func navigateToCardBlock(navTitle: String, success: @escaping VerificationActionHandler)
    func navigateToConfigureCard()
    func navigateToMovements()
    func navigateToMovementDetail(movement: MovementResponse)
    func successfulCardBlock()
    func successfulConfigureCard()
}
