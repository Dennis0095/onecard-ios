//
//  PromotionUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/07/23.
//

import Combine

protocol PromotionUseCaseProtocol {
    func consult(request: ConsultPromotionsRequest) -> AnyPublisher<ConsultPromotionsResponse, APIError>
}

class PromotionUseCase: PromotionUseCaseProtocol {
    
    private let promotionRepository: PromotionRepository
    
    init(promotionRepository: PromotionRepository) {
        self.promotionRepository = promotionRepository
    }
    
    func consult(request: ConsultPromotionsRequest) -> AnyPublisher<ConsultPromotionsResponse, APIError> {
        return promotionRepository.consult(request: request)
    }
}
