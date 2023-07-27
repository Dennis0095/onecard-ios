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
    func failureShowPromotions()
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
        let trackingCode = UserSessionManager.shared.getUser()?.cardTrackingCode ?? ""
        let request = ConsultPromotionsRequest(trackingCode: trackingCode)
        let cancellable = promotionUseCase.consult(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    self.delegate?.hideLoader {
                        let error = CustomError(title: "Error", description: error.localizedDescription)
                        if !self.wasShownViewPromotions {
                            self.delegate?.failureShowPromotions()
                        } else {
                            self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                        }
                    }
                }
            } receiveValue: { response in
                self.wasShownViewPromotions = true
                self.items = response.promotions ?? []
                self.delegate?.hideLoader {
                    self.delegate?.showPromotions()
                }
            }
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

//class PromotionsMockViewModel: PromotionsViewModelProtocol {
//    
//    var items: [PromotionResponse] = []
//    var router: PromotionsRouterDelegate
//    var delegate: PromotionsViewModelDelegate?
//    
//    init(router: PromotionsRouterDelegate) {
//        self.router = router
//    }
//    
//    func numberOfItems() -> Int {
//        return items.count
//    }
//    
//    func item(at index: Int) -> PromotionResponse {
//        return items[index]
//    }
//    
//    func isLast(at index: Int) -> Bool {
//        return (items.count - 1) == index
//    }
//    
//    
//    func fetchPromotions() {
//        delegate?.showLoader()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.delegate?.hideLoader(onHide: nil)
//            self.items = [PromotionResponse(id: "1", title: "Duplicar tus millas ClubMiles", message: "Pague en una cuota y solicite el fraccionamiento sin intereses en nuestra web"),
//                              PromotionResponse(id: "1", title: "Duplicar tus millas ClubMiles", message: "Pague en una cuota y solicite el fraccionamiento sin intereses en nuestra web"),
//                              PromotionResponse(id: "1", title: "Duplicar tus millas ClubMiles", message: "Pague en una cuota y solicite el fraccionamiento sin intereses en nuestra web")]
//            self.delegate?.showPromotions()
//        }
//    }
//}
