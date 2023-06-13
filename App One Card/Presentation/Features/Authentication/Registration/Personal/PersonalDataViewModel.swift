//
//  PersonalDataViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import Foundation

protocol PersonalDataViewModelProtocol {
    func nextStep()
    func showDateList(selected: Date?, action: @escaping SelectDateActionHandler, presented: @escaping VoidActionHandler)
}

class PersonalDataViewModel: PersonalDataViewModelProtocol {
    var router: AuthenticationRouterDelegate
    var verificationRouter: VerificationRouterDelegate
    
    init(router: AuthenticationRouterDelegate, verificationRouter: VerificationRouterDelegate) {
        self.router = router
        self.verificationRouter = verificationRouter
    }
    
    func nextStep() {
        verificationRouter.navigateToVerification(navTitle: "REGISTRO DE USUARIO DIGITAL", stepDescription: "Paso 3 de 4", success: { [weak self] in
            self?.router.navigateToLoginInformation()
        })
    }
    
    func showDateList(selected: Date?, action: @escaping SelectDateActionHandler, presented: @escaping VoidActionHandler) {
        router.showDateList(selected: selected, action: action, presented: presented)
    }
}
