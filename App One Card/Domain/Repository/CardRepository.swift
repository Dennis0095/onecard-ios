//
//  CardRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

protocol CardRepository {
    func activation(request: CardActivationRequest) -> AnyPublisher<CardActivationResponse, Error>
    //func block(request: ValidateKeyRequest) -> AnyPublisher<ValidateKeyResponse, Error>
}
