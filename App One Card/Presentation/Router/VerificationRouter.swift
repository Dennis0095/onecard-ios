//
//  VerificationRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/06/23.
//

import Foundation

protocol VerificationRouterDelegate: Router {
    func navigateToVerification(email: String, number: String, documentType: String, documentNumber: String, companyRUC: String, navTitle: String, stepDescription: String, operationType: String, maskPhoneEmail: Bool, success: @escaping VerificationActionHandler)
}
