//
//  HomeViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/06/23.
//

import Foundation

protocol HomeViewModelProtocol {
    func toCardLock()
    func toConfigureCard()
}

class HomeViewModel: HomeViewModelProtocol {
    var router: HomeRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    
    init(router: HomeRouterDelegate, successfulRouter: SuccessfulRouterDelegate) {
        self.router = router
        self.successfulRouter = successfulRouter
    }
    
    func toCardLock() {
        router.navigateToCardBlock(navTitle: "BLOQUEO DE TARJETA", success: { [weak self] in
            self?.successfulRouter.navigateToSuccessfulScreen(title: "Su tarjeta fue bloqueada", description: "Recuerde que para solicitar la reposición de la tarjeta debe comunicarse con su empleador.", button: "REGRESAR", accept: {
                self?.router.successfulCardBlock()
            })
        })
    }
    
    func toConfigureCard() {
        router.navigateToConfigureCard()
    }
}
