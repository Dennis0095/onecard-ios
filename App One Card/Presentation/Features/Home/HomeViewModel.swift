//
//  HomeViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/06/23.
//

import Foundation
import Combine

protocol HomeViewModelProtocol {
    var items: [MovementResponse] { get set }
    var banners: [BannerResponse] { get set }
    var timerBanners: Timer? { get set }
    
    func toCardLock()
    func toConfigureCard()
    func toChangePin()
    func toFrequentQuestions()
    func toCardActivation()
    func toMovements()
    func balanceInquiry()
    func consultMovements()
    func consultBanners()
    func getPromotionCategories()
    
    func numberOfItems() -> Int
    func item(at index: Int) -> MovementResponse
    func isLast(at index: Int) -> Bool
    func selectItem(movement: MovementResponse)
}

protocol HomeViewModelDelegate: LoaderDisplaying {
    func showBanners(isEmpty: Bool)
}

class HomeViewModel: HomeViewModelProtocol {
    var router: HomeRouterDelegate
    var authRouter: AuthenticationRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    var delegate: HomeViewModelDelegate?
    var items: [MovementResponse] = []
    var banners: [BannerResponse] = []
    var timerBanners: Timer?
    
    private let balanceUseCase: BalanceUseCaseProtocol
    private let movementUseCase: MovementUseCaseProtocol
    private let bannersUseCase: BannersUseCaseProtocol
    private let fetchPromotionCategoriesUseCase: FetchPromotionCategoriesUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: HomeRouterDelegate, 
         authRouter: AuthenticationRouterDelegate,
         successfulRouter: SuccessfulRouterDelegate,
         balanceUseCase: BalanceUseCaseProtocol,
         movementUseCase: MovementUseCaseProtocol,
         bannersUseCase: BannersUseCase,
         fetchPromotionCategoriesUseCase: FetchPromotionCategoriesUseCaseProtocol) {
        self.router = router
        self.successfulRouter = successfulRouter
        self.balanceUseCase = balanceUseCase
        self.movementUseCase = movementUseCase
        self.bannersUseCase = bannersUseCase
        self.authRouter = authRouter
        self.fetchPromotionCategoriesUseCase = fetchPromotionCategoriesUseCase
    }
    
    deinit {
        cancelRequests()
    }
    
    private func getAmountReal(amount: String) -> String {
        let amountConvert = amount.substring(with: 6..<(amount.count - 2))
        let amountDecimal = amount.substring(from: (amount.count - 2))
        return "\(amountConvert).\(amountDecimal)"
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(at index: Int) -> MovementResponse {
        return items[index]
    }
    
    func isLast(at index: Int) -> Bool {
        return (items.count - 1) == index
    }
    
    func toCardLock() {
        router.confirmCardLock {
            self.router.navigateToCardBlock(navTitle: "Bloqueo de tarjeta", success: { [weak self] idOtp in
                self?.successfulRouter.navigateToSuccessfulScreen(title: "Tu tarjeta fue bloqueada", description: "Recuerda que para solicitar la reposición de tu tarjeta debes enviar un correo a reposiciones@onecard.pe", button: "Regresar", image: #imageLiteral(resourceName: "card_lock_successfully.svg"), accept: {
                    self?.router.successfulCardBlock()
                })
            })
        }
    }
    
    func selectItem(movement: MovementResponse) {
        router.navigateToMovementDetail(movement: movement)
    }
    
    func toMovements() {
        router.navigateToMovements()
    }
    
    func toConfigureCard() {
        router.navigateToConfigureCard()
    }
    
    func toChangePin() {
        router.navigateToInputCurrentPin { operationId, _ in
            self.router.navigateToInputNewPin { _, newPin in
                self.router.navigateToInputPinConfirmation(newPin: newPin, operationId: operationId) { _, _ in
                    self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "Has cambiado tu PIN con éxito. Hemos enviado la constancia de operación a tu correo.", button: "Regresar", image: #imageLiteral(resourceName: "change_pin_successfully.svg")) {
                        self.router.backToHome()
                    }
                }
            }
        }
    }
    
    func toFrequentQuestions() {
        router.navigatetoFrequentQuestions()
    }
    
    func toCardActivation() {
        authRouter.navigateToPin { operationId, _ in
            self.authRouter.navigateToNewPin { _, newPin in
                self.authRouter.navigateToConfirmPin(operationId: operationId, newPin: newPin) { _, _ in
                    self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "Tu tarjeta ha sido activada con éxito. Hemos enviado la constancia de operación a tu correo.", button: Constants.accept, image: #imageLiteral(resourceName: "card_activated_successfully.svg")) {
                        CardSessionManager.shared.saveStatus(status: .ACTIVE)
                        self.router.backToHome()
                    }
                }
            }
        }
    }
    
    func balanceInquiry() {
        let trackingCode = UserSessionManager.shared.getUser()?.cardTrackingCode ?? ""
        
        let request = BalanceInquiryRequest(trackingCode: trackingCode)
        
        let cancellable = balanceUseCase.inquiry(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
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
                
                //self.delegate?.hideLoader {
                if response.rc == "0" {
                    DispatchQueue.main.async {
                        let balance = self.getAmountReal(amount: response.amount ?? "").convertStringToDecimalAndFormat(sign: response.sign ?? "")
                        HomeObserver.shared.updateAmount(amount: balance)
                    }
                } else {
//                    self.delegate?.showError(title: error.title, description: response.rcDescription ?? "") {
//                        self.balanceInquiry()
//                    }
                }
                //}
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func getPromotionCategories() {
        let trackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        let request = PromotionCategoriesRequest(authTrackingCode: trackingCode)
        fetchPromotionCategoriesUseCase.execute(request: request) {} onHideLoading: {} onSuccess: { _ in } onError: { _ in }
    }
    
    func consultMovements() {
        let trackingCode = UserSessionManager.shared.getUser()?.cardTrackingCode ?? ""
        
        let request = ConsultMovementsRequest(trackingCode: trackingCode)
        
        let cancellable = movementUseCase.consult(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.showError(title: error.title, description: error.description) {
                        switch apiError {
                        case .expiredSession:
                            self.router.logout(isManual: false)
                        default: break
                        }
                    }
                }
            } receiveValue: { response in
                HomeObserver.shared.updateMovements(movements: response.clientMovements)
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func consultBanners() {
        let trackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        
        let request = ConsultBannersRequest(authTrackingCode: trackingCode)
        
        let cancellable = bannersUseCase.consult(request: request)
            .receive(on: DispatchQueue.main)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.showError(title: error.title, description: error.description) {
                        switch apiError {
                        case .expiredSession:
                            self.router.logout(isManual: false)
                        default: break
                        }
                    }
                }
            } receiveValue: { response in
                if response.rc == "0" {
                    self.banners = response.banners ?? []
                    self.delegate?.showBanners(isEmpty: (response.banners ?? []).isEmpty)
                } else {
                    self.delegate?.showError(title: response.title ?? "", description: response.message ?? "", onAccept: nil)
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
