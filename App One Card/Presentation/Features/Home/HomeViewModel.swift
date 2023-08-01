//
//  HomeViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/06/23.
//

import Foundation
import Combine

protocol HomeViewModelProtocol {
    func toCardLock()
    func toConfigureCard()
    func toChangePin()
    func toCardActivation()
    func balanceInquiry()
    func consultMovements()
}

protocol HomeViewModelDelegate: LoaderDisplaying { }

class HomeViewModel: HomeViewModelProtocol {
    var router: HomeRouterDelegate
    var authRouter: AuthenticationRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    var movementsViewModel = MovementsViewModel()
    var delegate: HomeViewModelDelegate?
    
    private let balanceUseCase: BalanceUseCaseProtocol
    private let movementUseCase: MovementUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: HomeRouterDelegate, authRouter: AuthenticationRouterDelegate, successfulRouter: SuccessfulRouterDelegate, balanceUseCase: BalanceUseCaseProtocol, movementUseCase: MovementUseCaseProtocol) {
        self.router = router
        self.successfulRouter = successfulRouter
        self.balanceUseCase = balanceUseCase
        self.movementUseCase = movementUseCase
        self.authRouter = authRouter
    }
    
    deinit {
        cancelRequests()
    }
    
    func toCardLock() {
        router.confirmCardLock {
            self.router.navigateToCardBlock(navTitle: "BLOQUEO DE TARJETA", success: { [weak self] idOtp in
                self?.successfulRouter.navigateToSuccessfulScreen(title: "Su tarjeta fue bloqueada", description: "Recuerde que para solicitar la reposición de la tarjeta debe comunicarse con su empleador.", button: "REGRESAR", accept: {
                    self?.router.successfulCardBlock()
                })
            })
        }
    }
    
    func toConfigureCard() {
        router.navigateToConfigureCard()
    }
    
    func toChangePin() {
        router.navigateToInputCurrentPin { _ in
            self.router.navigateToInputNewPin { newPin in
                self.router.navigateToInputPinConfirmation(newPin: newPin) { _ in
                    self.successfulRouter.navigateToSuccessfulScreen(title: "¡Felicidades!", description: "Su tarjeta ha sido activada con éxito. Hemos enviado la constancia de operación a su correo.", button: "REGRESAR") {
                        self.router.backToHome()
                    }
                }
            }
        }
    }
    
    func toCardActivation() {
        authRouter.navigateToPin { _ in
            self.authRouter.navigateToNewPin { newPin in
                self.authRouter.navigateToConfirmPin(newPin: newPin) { _ in
                    self.successfulRouter.navigateToSuccessfulScreen(title: "¡Felicidades!", description: "Su tarjeta ha sido activada con éxito. Hemos enviado la constancia de operación a su correo.", button: Constants.accept) {
                        self.router.backToHome()
                    }
                }
            }
        }
    }
    
    func balanceInquiry() {
        //delegate?.showLoader()
        
        let request = BalanceInquiryRequest(segCode: "12345687910111213140")
  
        let cancellable = balanceUseCase.inquiry(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    self.delegate?.hideLoader {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            } receiveValue: { response in
                let description = response.description ?? ""
                let error = APIError.defaultError.error()
                
                self.delegate?.hideLoader {
                    if response.rc == "0" {
                        DispatchQueue.main.async {
                            let balance = response.amount?.parseAmountToCurrency(type: response.currency ?? "", sign: response.sign ?? "")
                            HomeObserver.shared.updateAmount(amount: balance)
                        }
                    } else {
                        self.delegate?.showError(title: error.title, description: error.description) {
                            self.balanceInquiry()
                        }
                    }
                }
            }
        
        cancellable.store(in: &cancellables)
        
//        balanceUseCase.inquiry(request: request) { result in
//            switch result {
//            case .success(let response):
//                DispatchQueue.main.async {
//                    let balance = response.amount?.parseAmountToCurrency(type: response.currency ?? "", sign: response.sign ?? "")
//                    HomeObserver.shared.updateAmount(amount: balance)
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
////                    self.router.showMessageError(title: error.title, description: error.description) {
////                        if error.actionAfterFailure {
////                            self.balanceInquiry()
////                        }
////                    }
//                }
//            }
//        }
    }
    
    func consultMovements() {
        delegate?.showLoader()
        
        let request = ConsultMovementsRequest(segCode: "12345687910111213140")
        
        let cancellable = movementUseCase.consult(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    self.delegate?.hideLoader {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            } receiveValue: { response in
                self.delegate?.hideLoader {
                    DispatchQueue.main.async {
                        HomeObserver.shared.updateMovements(movements: response.clientMovements)
                    }
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
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
