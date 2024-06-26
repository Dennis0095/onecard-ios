//
//  ConfigureCardViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/06/23.
//

import Foundation
import Combine

protocol ConfigureCardViewModelProtocol {
    var items: [ConfigureResponse] { get set }
    var delegate: ConfigureCardViewModelDelegate? { get set }
    var wasShownViewConfigureCard: Bool { get set }
    var cardStatus: CardStatusResponse? { get set }
    var onlineShoppingStatus: CardOnlineShoppingStatusResponse? { get set }
    var configureCardChanges: ConfigureCardChanges? { get set }
    
    func numberOfItems() -> Int
    func item(at index: Int) -> ConfigureResponse
    func isLast(at index: Int) -> Bool
    func getCardStatusAndOnlineShoppingStatus()
    func changeStatus(at index: Int, status: Bool)
    func existsChanges() -> Bool
    func saveChanges()
    func cancelRequests()
}

struct ConfigureResponse {
    let id: String?
    let title: String?
    let message: String?
    var enable: Bool?
    var isOn: Bool?
}

protocol ConfigureCardViewModelDelegate: LoaderDisplaying {
    func changeStatus()
    func successGetStatus()
    func failureGetStatus(error: APIError)
}

class ConfigureCardViewModel: ConfigureCardViewModelProtocol {
    private let cardUseCase: CardUseCase
    private var cancellables = Set<AnyCancellable>()
    
    var items: [ConfigureResponse] = []
    var router: HomeRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    var delegate: ConfigureCardViewModelDelegate?
    var wasShownViewConfigureCard: Bool = false
    var cardStatus: CardStatusResponse?
    var onlineShoppingStatus: CardOnlineShoppingStatusResponse?
    var configureCardChanges: ConfigureCardChanges? = .nothing
    
    init(router: HomeRouterDelegate, successfulRouter: SuccessfulRouterDelegate, cardUseCase: CardUseCase) {
        self.router = router
        self.successfulRouter = successfulRouter
        self.cardUseCase = cardUseCase
    }
    
    deinit {
        cancelRequests()
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(at index: Int) -> ConfigureResponse {
        return items[index]
    }
    
    func isLast(at index: Int) -> Bool {
        return (items.count - 1) == index
    }
    
    func changeStatus(at index: Int, status: Bool) {
        items[index].isOn = status
        items[1].enable = items[0].isOn == true
        delegate?.changeStatus()
    }
    
    func existsChanges() -> Bool {
        let cardStatus = cardStatus?.status == "A"
        let onlineShoppingStatus = onlineShoppingStatus?.status == "S"
        
        if cardStatus != items[0].isOn && onlineShoppingStatus != items[1].isOn {
            configureCardChanges = cardStatus ? .bothOnlineShopping : .bothCard
        } else if cardStatus == items[0].isOn && onlineShoppingStatus != items[1].isOn {
            configureCardChanges = .onlineShopping
        } else if cardStatus != items[0].isOn && onlineShoppingStatus == items[1].isOn {
            configureCardChanges = cardStatus ? .cardLock : .cardActivation
        } else if cardStatus == items[0].isOn && onlineShoppingStatus == items[1].isOn {
            configureCardChanges = .nothing
        }
        
        return !(configureCardChanges == .nothing)
    }
    
    func getCardStatusAndOnlineShoppingStatus() {
        delegate?.showLoader()
        
        let trackingCode = UserSessionManager.shared.getUser()?.cardTrackingCode ?? ""
        let cardStatusRequest = CardStatusRequest(trackingCode: trackingCode)
        let cardOnlineShoppingStatusRequest = CardOnlineShoppingStatusRequest(trackingCode: trackingCode, type: "2")
        
        let cancellable = Publishers.Zip(
            cardUseCase.status(request: cardStatusRequest),
            cardUseCase.onlineShoppingStatus(request: cardOnlineShoppingStatusRequest)
        )
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    switch apiError {
                    case.expiredSession:
                        self.delegate?.showError(title: error.title, description: error.description) {
                            self.router.logout(isManual: false)
                        }
                    default:
                        if !self.wasShownViewConfigureCard {
                            self.delegate?.failureGetStatus(error: apiError)
                        } else {
                            self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                        }
                    }
                }
            } receiveValue: { response in
                let apiError = APIError.defaultError
                let error = apiError.error()
                self.cardStatus = response.0
                self.onlineShoppingStatus = response.1
                
                self.delegate?.hideLoader()
                if response.0.rc == "0" && response.1.rc == "0" {
                    self.wasShownViewConfigureCard = true
                    self.items = [
                        ConfigureResponse(id: "1", title: "APAGAR Y PRENDER TARJETA", message: "Recuerda que no podrás hacer uso de tu tarjeta mientras esté apagada.", enable: true, isOn: self.cardStatus?.status == "A"),
                        ConfigureResponse(id: "2", title: "COMPRAS POR INTERNET", message: nil, enable: self.cardStatus?.status == "A", isOn: self.onlineShoppingStatus?.status == "S")
                    ]
                    self.delegate?.changeStatus()
                    self.delegate?.successGetStatus()
                } else {
                    if !self.wasShownViewConfigureCard {
                        self.delegate?.failureGetStatus(error: apiError)
                    } else {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            }
        cancellable.store(in: &cancellables)
    }
    
    func saveChanges() {
        delegate?.showLoader()
        
        let trackingCode = UserSessionManager.shared.getUser()?.cardTrackingCode ?? ""
        
        let cardActivationRequest = CardActivationRequest(trackingCode: trackingCode)
        let cardLockRequest = CardLockRequest(trackingCode: trackingCode, reason: "TE")
        let changeCardOnlineShoppingStatusRequest = ChangeCardOnlineShoppingStatusRequest(trackingCode: trackingCode, type: "2", action: items[1].isOn == true ? "S" : "N")
        
        switch configureCardChanges {
        case .cardActivation:
            let cancellable = cardUseCase.activation(request: cardActivationRequest)
                .sink { publisher in
                    switch publisher {
                    case .finished: break
                    case .failure(let apiError):
                        let error = apiError.error()
                        
                        self.delegate?.hideLoader()
                        self.delegate?.showError(title: error.title, description: error.description) {
                            switch apiError {
                            case .expiredSession:
                                self.router.logout(isManual: false)
                            default: break
                            }
                        }
                    }
                } receiveValue: { response in
                    let error = APIError.defaultError.error()
                    
                    self.delegate?.hideLoader()
                    if response.rc == "0" {
                        self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "La configuración de tu tarjeta se ha guardado con éxito. Hemos enviado la constancia de operación a tu correo. ", button: "Regresar", image: #imageLiteral(resourceName: "card_activated_successfully.svg"), accept: {
                            self.router.successfulConfigureCard()
                        })
                    } else {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            cancellable.store(in: &cancellables)
        case .cardLock:
            let cancellable = cardUseCase.cardLock(request: cardLockRequest)
                .sink { publisher in
                    switch publisher {
                    case .finished: break
                    case .failure(let apiError):
                        let error = apiError.error()
                        
                        self.delegate?.hideLoader()
                        self.delegate?.showError(title: error.title, description: error.description) {
                            switch apiError {
                            case .expiredSession:
                                self.router.logout(isManual: false)
                            default: break
                            }
                        }
                    }
                } receiveValue: { response in
                    let error = APIError.defaultError.error()
                    
                    self.delegate?.hideLoader()
                    if response.rc == "0" {
                        self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "La configuración de tu tarjeta se ha guardado con éxito. Hemos enviado la constancia de operación a tu correo. ", button: "Regresar", image: #imageLiteral(resourceName: "card_activated_successfully.svg"), accept: {
                            self.router.successfulConfigureCard()
                        })
                    } else {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            cancellable.store(in: &cancellables)
        case .onlineShopping:
            let cancellable = cardUseCase.changeCardOnlineShoppingStatus(request: changeCardOnlineShoppingStatusRequest)
                .sink { publisher in
                    switch publisher {
                    case .finished: break
                    case .failure(let apiError):
                        let error = apiError.error()
                        
                        self.delegate?.hideLoader()
                        self.delegate?.showError(title: error.title, description: error.description) {
                            switch apiError {
                            case .expiredSession:
                                self.router.logout(isManual: false)
                            default: break
                            }
                        }
                    }
                } receiveValue: { response in
                    let error = APIError.defaultError.error()
                    
                    self.delegate?.hideLoader()
                    if response.rc == "0" {
                        self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "La configuración de tu tarjeta se ha guardado con éxito. Hemos enviado la constancia de operación a tu correo. ", button: "Regresar", image: #imageLiteral(resourceName: "card_activated_successfully.svg"), accept: {
                            self.router.successfulConfigureCard()
                        })
                    } else {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            cancellable.store(in: &cancellables)
        case .bothCard:
            let cancellable = Publishers.Zip(
                cardUseCase.activation(request: cardActivationRequest),
                cardUseCase.changeCardOnlineShoppingStatus(request: changeCardOnlineShoppingStatusRequest)
            )
                .sink { publisher in
                    switch publisher {
                    case .finished: break
                    case .failure(let apiError):
                        let error = apiError.error()
                        
                        self.delegate?.hideLoader()
                        self.delegate?.showError(title: error.title, description: error.description) {
                            switch apiError {
                            case .expiredSession:
                                self.router.logout(isManual: false)
                            default: break
                            }
                        }
                    }
                } receiveValue: { response in
                    let error = APIError.defaultError.error()
                    
                    self.delegate?.hideLoader()
                    if response.0.rc == "0" && response.1.rc == "0" {
                        self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "La configuración de tu tarjeta se ha guardado con éxito. Hemos enviado la constancia de operación a tu correo. ", button: "Regresar", image: #imageLiteral(resourceName: "card_activated_successfully.svg"), accept: {
                            self.router.successfulConfigureCard()
                        })
                    } else {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            cancellable.store(in: &cancellables)
        case .bothOnlineShopping:
            let cancellable = Publishers.Zip(
                cardUseCase.changeCardOnlineShoppingStatus(request: changeCardOnlineShoppingStatusRequest),
                cardUseCase.cardLock(request: cardLockRequest)
            )
                .sink { publisher in
                    switch publisher {
                    case .finished: break
                    case .failure(let apiError):
                        let error = apiError.error()
                        
                        self.delegate?.hideLoader()
                        self.delegate?.showError(title: error.title, description: error.description) {
                            switch apiError {
                            case .expiredSession:
                                self.router.logout(isManual: false)
                            default: break
                            }
                        }
                    }
                } receiveValue: { response in
                    let error = APIError.defaultError.error()
                    
                    self.delegate?.hideLoader()
                    if response.0.rc == "0" && response.1.rc == "0" {
                        self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "La configuración de tu tarjeta se ha guardado con éxito. Hemos enviado la constancia de operación a tu correo. ", button: "Regresar", image: #imageLiteral(resourceName: "card_activated_successfully.svg"), accept: {
                            self.router.successfulConfigureCard()
                        })
                    } else {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            cancellable.store(in: &cancellables)
        default:
            self.delegate?.hideLoader()
        }
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

enum ConfigureCardChanges {
    case cardLock
    case cardActivation
    case onlineShopping
    case bothCard
    case bothOnlineShopping
    case nothing
}
