//
//  PromotionDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/07/23.
//

import Combine

class PromotionDataRepository: PromotionRepository {
    func consult(request: ConsultPromotionsRequest) -> AnyPublisher<ConsultPromotionsResponse, Error> {
        return APIClient.callAPI(route: .consultPromotions, method: .post, request: request)
    }
}
