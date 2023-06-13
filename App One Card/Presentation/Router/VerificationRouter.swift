//
//  VerificationRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/06/23.
//

import Foundation

protocol VerificationRouterDelegate: Router {
    func navigateToVerification(navTitle: String, stepDescription: String , success: @escaping VoidActionHandler)
}
