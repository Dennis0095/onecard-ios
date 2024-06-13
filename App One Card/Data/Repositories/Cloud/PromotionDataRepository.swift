//
//  PromotionDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/07/23.
//

import Combine

class PromotionDataRepository: PromotionRepository {
    
    private let dataSource: PromotionDataSourceProtocol
    private let localDataSource: PromotionLocalDataSourceProtocol
    
    init(dataSource: PromotionDataSourceProtocol,
         localDataSource: PromotionLocalDataSourceProtocol) {
        self.dataSource = dataSource
        self.localDataSource = localDataSource
    }
    
    func consult(request: ConsultPromotionsRequest) -> AnyPublisher<ConsultPromotionsResponse, APIError> {
        return dataSource.consult(request: request)
    }
    
    func detail(request: PromotionDetailRequest) -> AnyPublisher<PromotionDetailResponse, APIError> {
        return dataSource.detail(request: request)
    }
    
    func getCategories(request: PromotionCategoriesRequest) -> AnyPublisher<PromotionCategoriesResponse, APIError> {
        return dataSource.getCategories(request: request)
    }
}
