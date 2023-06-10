//
//  VerificationViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 7/06/23.
//

import Foundation

protocol VerificationViewModelProtocol {
    func nextStep()
}

class VerificationViewModel: VerificationViewModelProtocol {
    var router: AuthenticationRouterDelegate?
    
    func nextStep() {
        router?.navigateToLoginInformation()
    }
}
