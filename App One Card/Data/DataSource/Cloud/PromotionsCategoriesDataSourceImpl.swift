//
//  PromotionsCategoriesDataSourceImpl.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation
import Combine

protocol PromotionsCategoriesDataSource {
    func getCategories(request: BaseRequest) -> AnyPublisher<PromotionCategoriesResponse, APIError>
}

class PromotionsCategoriesDataSourceImpl: PromotionsCategoriesDataSource {
    func getCategories(request: BaseRequest) -> AnyPublisher<PromotionCategoriesResponse, APIError> {
        return APIClient.callAPI(route: .promotionCategories, method: .post, request: request)
    }
}
