//
//  PromotionsViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 19/07/23.
//

import Combine

protocol PromotionsViewModelProtocol {
    var wasShownViewPromotions: Bool { get set }
    var items: [PromotionResponse] { get set }
    var router: PromotionsRouterDelegate { get set }
    var delegate: PromotionsViewModelDelegate? { get set }
    
    func numberOfItems() -> Int
    func item(at index: Int) -> PromotionResponse
    func isLast(at index: Int) -> Bool
    func fetchPromotions()
}

protocol PromotionsViewModelDelegate: LoaderDisplaying {
    func showPromotions()
    func failureShowPromotions(error: APIError)
}

class PromotionsViewModel: PromotionsViewModelProtocol {
    private let promotionUseCase: PromotionUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    var wasShownViewPromotions: Bool = false
    var items: [PromotionResponse] = []
    var router: PromotionsRouterDelegate
    var delegate: PromotionsViewModelDelegate?
    
    init(router: PromotionsRouterDelegate, promotionUseCase: PromotionUseCase) {
        self.router = router
        self.promotionUseCase = promotionUseCase
    }
    
    deinit {
        cancelRequests()
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(at index: Int) -> PromotionResponse {
        return items[index]
    }
    
    func isLast(at index: Int) -> Bool {
        return (items.count - 1) == index
    }
    
    func fetchPromotions() {
        delegate?.showLoader()
        let trackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        let request = ConsultPromotionsRequest(authTrackingCode: trackingCode)
        let cancellable = promotionUseCase.consult(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    switch apiError {
                    case .expiredSession:
                        self.delegate?.showError(title: error.title, description: error.description) {
                            self.router.logout(isManual: false)
                        }
                    default:
                        if !self.wasShownViewPromotions {
                            self.delegate?.failureShowPromotions(error: apiError)
                        } else {
                            self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                        }
                    }
                }
            } receiveValue: { response in
                self.wasShownViewPromotions = true
                self.items = response.promotions ?? []
                self.delegate?.hideLoader()
                self.delegate?.showPromotions()
            }
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
