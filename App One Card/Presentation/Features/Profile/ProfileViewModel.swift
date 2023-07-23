//
//  ProfileViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/06/23.
//

import Foundation

protocol ProfileViewModelProtocol {
    func toEditMail()
    func toEditUser()
    func toEditPassword()
}

class ProfileViewModel: ProfileViewModelProtocol {
    var router: ProfileRouterDelegate
    var verificationRouter: VerificationRouterDelegate
    
    init(router: ProfileRouterDelegate, verificationRouter: VerificationRouterDelegate) {
        self.router = router
        self.verificationRouter = verificationRouter
    }
    
    func toEditMail() {
        router.toEditMail()
    }
    
    func toEditUser() {
        //router.toEditUser()
        verificationRouter.navigateToVerification(email: "arambulotech@gmail.com", number: "982221121", navTitle: "CAMBIO DE USUARIO", stepDescription: "Paso 1 de 2", success: { [weak self] idOtp in
//            self?.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "Ha modificado su usuario con éxito.", button: "REGRESAR", accept: {
//                self?.profileRouter.successfulEditProfile()
//            })
            self?.router.toEditUser()
        })
    }
    
    func toEditPassword() {
        router.toEditPassword()
    }
}
