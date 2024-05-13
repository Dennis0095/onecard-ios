//
//  PromotionDetailViewModel.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 13/05/24.
//

import Foundation

protocol PromotionDetailViewModelProtocol {
    var detail: PromotionDetailResponse { get set }
    var router: PromotionsRouterDelegate { get set }
    var delegate: PromotionDetailViewModelDelegate? { get set }
    
    func onAppear()
    func showTerms()
}

protocol PromotionDetailViewModelDelegate {
    func showInfoDetail(detail: PromotionDetailResponse)
}

class PromotionDetailViewModel: PromotionDetailViewModelProtocol {
    var delegate: PromotionDetailViewModelDelegate?
    var detail: PromotionDetailResponse
    var router: PromotionsRouterDelegate
    
    init(detail: PromotionDetailResponse, router: PromotionsRouterDelegate) {
        self.detail = detail
        self.router = router
    }
    
    func onAppear() {
        delegate?.showInfoDetail(detail: detail)
    }
    
    func showTerms() {
        router.showTermsConditions(terms: detail.termsConditions ?? "")
    }
}
