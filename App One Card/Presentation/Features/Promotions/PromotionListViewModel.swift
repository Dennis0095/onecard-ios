//
//  PromotionListViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 19/07/23.
//

import Foundation

protocol PromotionListViewModelProtocol {
    var items: [PromotionResponse] { get set }
    var router: PromotionsRouterDelegate { get set }
    var delegate: PromotionListViewModelDelegate? { get set }
    
    func numberOfItems() -> Int
    func item(at index: Int) -> PromotionResponse
    func isLast(at index: Int) -> Bool
    func fetchPromotions()
}

struct PromotionResponse {
    let id: String?
    let title: String?
    let message: String?
}

protocol PromotionListViewModelDelegate: LoaderDisplaying {
    func showPromotions()
}

class PromotionListViewModel: PromotionListViewModelProtocol {
    
    var items: [PromotionResponse] = []
    var router: PromotionsRouterDelegate
    var delegate: PromotionListViewModelDelegate?
    
    init(router: PromotionsRouterDelegate) {
        self.router = router
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
    
    func fetchPromotions() {    }
    
}

class PromotionListMockViewModel: PromotionListViewModelProtocol {
    
    var items: [PromotionResponse] = []
    var router: PromotionsRouterDelegate
    var delegate: PromotionListViewModelDelegate?
    
    init(router: PromotionsRouterDelegate) {
        self.router = router
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.delegate?.hideLoader(onHide: nil)
            self.items = [PromotionResponse(id: "1", title: "Duplicar tus millas ClubMiles", message: "Pague en una cuota y solicite el fraccionamiento sin intereses en nuestra web"),
                              PromotionResponse(id: "1", title: "Duplicar tus millas ClubMiles", message: "Pague en una cuota y solicite el fraccionamiento sin intereses en nuestra web"),
                              PromotionResponse(id: "1", title: "Duplicar tus millas ClubMiles", message: "Pague en una cuota y solicite el fraccionamiento sin intereses en nuestra web")]
            self.delegate?.showPromotions()
        }
    }
    
}
