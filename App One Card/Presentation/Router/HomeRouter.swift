//
//  HomeRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/06/23.
//

import Foundation

protocol HomeRouterDelegate: Router {
    func navigateToCardBlock(email: String, number: String, navTitle: String, success: @escaping VerificationActionHandler)
    func navigateToConfigureCard()
    func successfulCardBlock()
    func successfulConfigureCard()
}
