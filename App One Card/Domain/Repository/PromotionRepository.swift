//
//  PromotionRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/07/23.
//

import Combine

protocol PromotionRepository {
    func consult(request: ConsultPromotionsRequest) -> AnyPublisher<ConsultPromotionsResponse, Error>
}
