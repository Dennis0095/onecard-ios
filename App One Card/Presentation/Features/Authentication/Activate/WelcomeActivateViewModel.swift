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
        router.navigateToPin { operationId, _ in
            self.router.navigateToNewPin { _, newPin in
                self.router.navigateToConfirmPin(operationId: operationId, newPin: newPin) { _, _ in
                    self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "Tu tarjeta ha sido activada con éxito. Hemos enviado la constancia de operación a tu correo.", button: Constants.accept, image: #imageLiteral(resourceName: "card_activated_successfully.svg")) {
                        CardSessionManager.shared.saveStatus(status: .ACTIVE)
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
