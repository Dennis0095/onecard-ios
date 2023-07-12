//
//  CardDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

class CardDataRepository: CardRepository {
    func activation(request: CardActivationRequest) -> AnyPublisher<CardActivationResponse, Error> {
        return APIClient.callAPI(route: .cardActivation, method: .post, request: request, showLoading: true)
    }
}
