//
//  PromotionsRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 19/07/23.
//

import Foundation

protocol PromotionsRouterDelegate: Router {
    func toPromotionDetail(detail: PromotionDetailResponse)
    func toFilters(categories: [PromotionCategory], filter: VoidActionHandler?)
    func showTermsConditions(terms: String)
}
