//
//  EditMailViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/06/23.
//

import Foundation

protocol EditMailViewModelProtocol {
    func successfulEdit()
}

class EditMailViewModel: EditMailViewModelProtocol {
    var profileRouter: ProfileRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    var verificationRouter: VerificationRouterDelegate
    
    init(profileRouter: ProfileRouterDelegate, successfulRouter: SuccessfulRouterDelegate, verificationRouter: VerificationRouterDelegate) {
        self.profileRouter = profileRouter
        self.successfulRouter = successfulRouter
        self.verificationRouter = verificationRouter
    }
    
    func successfulEdit() {
        verificationRouter.navigateToVerification(navTitle: "EDITAR CORREO", stepDescription: "Paso 2 de 2", success: { [weak self] in
            self?.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "Ha modificado su correo electrónico con éxito.", button: "REGRESAR", accept: {
                self?.profileRouter.successfulEditProfile()
            })
        })
    }
}
