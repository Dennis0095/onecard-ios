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
    func balanceInquiry()
}

class HomeViewModel: HomeViewModelProtocol {
    var router: HomeRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    
    private let balanceUseCase: BalanceUseCaseProtocol
    
    init(router: HomeRouterDelegate, successfulRouter: SuccessfulRouterDelegate, balanceUseCase: BalanceUseCaseProtocol) {
        self.router = router
        self.successfulRouter = successfulRouter
        self.balanceUseCase = balanceUseCase
    }
    
    func toCardLock() {
        router.navigateToCardBlock(email: "", number: "", navTitle: "BLOQUEO DE TARJETA", success: { [weak self] idOtp in
            self?.successfulRouter.navigateToSuccessfulScreen(title: "Su tarjeta fue bloqueada", description: "Recuerde que para solicitar la reposición de la tarjeta debe comunicarse con su empleador.", button: "REGRESAR", accept: {
                self?.router.successfulCardBlock()
            })
        })
    }
    
    func toConfigureCard() {
        router.navigateToConfigureCard()
    }
    
    func balanceInquiry() {
        let request = BalanceInquiryRequest(segCode: "12345687910111213140")
        
        balanceUseCase.inquiry(request: request) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    let balance = response.amount?.parseAmountToCurrency(type: response.currency ?? "")
                    HomeObserver.shared.updateAmount(amount: balance)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.router.showMessageError(title: error.title, description: error.description) {
                        if error.actionAfterFailure {
                            self.balanceInquiry()
                        }
                    }
                }
            }
        }
    }
}

enum Currency {
    case Dolars
    case Soles
    
    var type: String {
        switch self {
        case .Dolars:
            return "840"
        case .Soles:
            return "604"
        }
    }
}


//enum SignStandard: String {
//    case C = "840"
//    case D = "604"
//
//    var type: String {
//        switch self {
//        case .C:
//            return "840"
//        case .D:
//            return "604"
//        }
//    }
//}
