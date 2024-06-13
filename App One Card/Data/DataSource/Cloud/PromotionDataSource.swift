//
//  PromotionDataSource.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 13/06/24.
//

import Foundation
import Combine

class PromotionDataSource: PromotionDataSourceProtocol {
    func consult(request: ConsultPromotionsRequest) -> AnyPublisher<ConsultPromotionsResponse, APIError> {
        return APIClient.callAPI(route: .consultPromotions, method: .post, request: request)
    }
    
    func detail(request: PromotionDetailRequest) -> AnyPublisher<PromotionDetailResponse, APIError> {
        return APIClient.callAPI(route: .promotionDetail, method: .post, request: request)
    }
    
    func getCategories(request: PromotionCategoriesRequest) -> AnyPublisher<PromotionCategoriesResponse, APIError> {
        return APIClient.callAPI(route: .promotionCategories, method: .post, request: request)
    }
}
