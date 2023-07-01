//
//  EditUserViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/06/23.
//

import Foundation

protocol EditUserViewModelProtocol {
    func successfulEdit()
}

class EditUserViewModel: EditUserViewModelProtocol {
    var profileRouter: ProfileRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    var verificationRouter: VerificationRouterDelegate
    
    init(profileRouter: ProfileRouterDelegate, successfulRouter: SuccessfulRouterDelegate, verificationRouter: VerificationRouterDelegate) {
        self.profileRouter = profileRouter
        self.successfulRouter = successfulRouter
        self.verificationRouter = verificationRouter
    }
    
    func successfulEdit() {
        verificationRouter.navigateToVerification(email: "", number: "", navTitle: "CAMBIO DE USUARIO", stepDescription: "Paso 2 de 2", success: { [weak self] idOtp in
            self?.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "Ha modificado su usuario con éxito.", button: "REGRESAR", accept: {
                self?.profileRouter.successfulEditProfile()
            })
        })
    }
}
