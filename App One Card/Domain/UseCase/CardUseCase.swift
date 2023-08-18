//
//  CardUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

protocol CardUseCaseProtocol {
    func activation(request: CardActivationRequest) -> AnyPublisher<CardActivationResponse, APIError>
    func status(request: CardStatusRequest) -> AnyPublisher<CardStatusResponse, APIError>
    func onlineShoppingStatus(request: CardOnlineShoppingStatusRequest) -> AnyPublisher<CardOnlineShoppingStatusResponse, APIError>
    func prepaidCardLock(request: PrepaidCardLockRequest) -> AnyPublisher<PrepaidCardLockResponse, APIError>
    func cardLock(request: CardLockRequest) -> AnyPublisher<CardLockResponse, APIError>
    func changeCardOnlineShoppingStatus(request: ChangeCardOnlineShoppingStatusRequest) -> AnyPublisher<ChangeCardOnlineShoppingStatusResponse, APIError>
}

class CardUseCase: CardUseCaseProtocol {
    private let cardRepository: CardRepository
    
    init(cardRepository: CardRepository) {
        self.cardRepository = cardRepository
    }
    
    func activation(request: CardActivationRequest) -> AnyPublisher<CardActivationResponse, APIError> {
        return cardRepository.activation(request: request)
    }
    
    func status(request: CardStatusRequest) -> AnyPublisher<CardStatusResponse, APIError> {
        return cardRepository.status(request: request)
    }
    
    func onlineShoppingStatus(request: CardOnlineShoppingStatusRequest) -> AnyPublisher<CardOnlineShoppingStatusResponse, APIError> {
        return cardRepository.onlineShoppingStatus(request: request)
    }
    
    func prepaidCardLock(request: PrepaidCardLockRequest) -> AnyPublisher<PrepaidCardLockResponse, APIError> {
        return cardRepository.prepaidCardLock(request: request)
    }
    
    func cardLock(request: CardLockRequest) -> AnyPublisher<CardLockResponse, APIError> {
        return cardRepository.lock(request: request)
    }
    
    func changeCardOnlineShoppingStatus(request: ChangeCardOnlineShoppingStatusRequest) -> AnyPublisher<ChangeCardOnlineShoppingStatusResponse, APIError> {
        return cardRepository.changeCardOnlineShoppingStatus(request: request)
    }
}
