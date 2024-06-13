//
//  PromotionDataSourceProtocol.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 13/06/24.
//

import Foundation
import Combine

protocol PromotionDataSourceProtocol {
    func getCategories(request: PromotionCategoriesRequest) -> AnyPublisher<PromotionCategoriesResponse, APIError>
    func consult(request: ConsultPromotionsRequest) -> AnyPublisher<ConsultPromotionsResponse, APIError>
    func detail(request: PromotionDetailRequest) -> AnyPublisher<PromotionDetailResponse, APIError>
}
