//
//  CardUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

protocol CardUseCaseProtocol {
    func activation(request: CardActivationRequest) -> AnyPublisher<CardActivationResponse, Error>
    func status(request: CardStatusRequest) -> AnyPublisher<CardStatusResponse, Error>
    func onlineShoppingStatus(request: CardOnlineShoppingStatusRequest) -> AnyPublisher<CardOnlineShoppingStatusResponse, Error>
    func temporaryLock(request: TemporaryCardLockRequest) -> AnyPublisher<TemporaryCardLockResponse, Error>
    func temporaryLock(request: CardLockRequest) -> AnyPublisher<CardLockResponse, Error>
    func changeCardOnlineShoppingStatus(request: ChangeCardOnlineShoppingStatusRequest) -> AnyPublisher<ChangeCardOnlineShoppingStatusResponse, Error>
}

class CardUseCase: CardUseCaseProtocol {
    private let cardRepository: CardRepository
    
    init(cardRepository: CardRepository) {
        self.cardRepository = cardRepository
    }
    
    func activation(request: CardActivationRequest) -> AnyPublisher<CardActivationResponse, Error> {
        return cardRepository.activation(request: request)
    }
    
    func status(request: CardStatusRequest) -> AnyPublisher<CardStatusResponse, Error> {
        return cardRepository.status(request: request)
    }
    
    func onlineShoppingStatus(request: CardOnlineShoppingStatusRequest) -> AnyPublisher<CardOnlineShoppingStatusResponse, Error> {
        return cardRepository.onlineShoppingStatus(request: request)
    }
    
    func temporaryLock(request: TemporaryCardLockRequest) -> AnyPublisher<TemporaryCardLockResponse, Error> {
        return cardRepository.temporaryLock(request: request)
    }
    
    func temporaryLock(request: CardLockRequest) -> AnyPublisher<CardLockResponse, Error> {
        return cardRepository.lock(request: request)
    }
    
    func changeCardOnlineShoppingStatus(request: ChangeCardOnlineShoppingStatusRequest) -> AnyPublisher<ChangeCardOnlineShoppingStatusResponse, Error> {
        return cardRepository.changeCardOnlineShoppingStatus(request: request)
    }
}
