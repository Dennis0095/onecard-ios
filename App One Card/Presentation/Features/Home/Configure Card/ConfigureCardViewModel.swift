//
//  ConfigureCardViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/06/23.
//

import Foundation

protocol ConfigureCardViewModelProtocol {
    func toConfigureCard()
    func saveChanges()
}

class ConfigureCardViewModel: ConfigureCardViewModelProtocol {
    var router: HomeRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    
    init(router: HomeRouterDelegate, successfulRouter: SuccessfulRouterDelegate) {
        self.router = router
        self.successfulRouter = successfulRouter
    }
    
    func toConfigureCard() {
        router.navigateToConfigureCard()
    }
    
    func saveChanges() {
        self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "La configuración de su tarjeta se ha guardado con éxito. Hemos enviado la constancia de operación a su correo. ", button: "REGRESAR", accept: {
            self.router.successfulConfigureCard()
        })
    }
}
