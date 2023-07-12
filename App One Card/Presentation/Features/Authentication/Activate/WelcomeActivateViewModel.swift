//
//  WelcomeActivateViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 20/06/23.
//

import Foundation

protocol WelcomeActivateViewModelProtocol {
    func toCardActivation()
    func toChangePin()
    func toConfirmPin()
    func toHome()
}

class WelcomeActivateViewModel: WelcomeActivateViewModelProtocol {
    var router: AuthenticationRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    
    init(router: AuthenticationRouterDelegate, successfulRouter: SuccessfulRouterDelegate) {
        self.router = router
        self.successfulRouter = successfulRouter
    }
    
    func toCardActivation() {
        router.navigateToPin { _ in
            self.router.navigateToNewPin { newPin in
                self.router.navigateToConfirmPin(newPin: newPin) { _ in
                    self.successfulRouter.navigateToSuccessfulScreen(title: "¡Felicidades!", description: "Su tarjeta ha sido activada con éxito. Hemos enviado la constancia de operación a su correo.", button: Constants.accept) {
                        self.router.navigateToHome()
                    }
                }
            }
        }
    }
    
    func toChangePin() {
//        router.navigateToNewPin { _ in
//
//        }
    }

    func toConfirmPin() {
//        router.navigateToConfirmPin { _ in
//
//        }
    }
    
    func toHome() {
        router.navigateToHome()
    }
}
