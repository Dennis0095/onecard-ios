//
//  CardUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

protocol CardUseCaseProtocol {
    func activation(request: CardActivationRequest) -> AnyPublisher<CardActivationResponse, CustomError>
    func status(request: CardStatusRequest) -> AnyPublisher<CardStatusResponse, CustomError>
    func onlineShoppingStatus(request: CardOnlineShoppingStatusRequest) -> AnyPublisher<CardOnlineShoppingStatusResponse, CustomError>
    func prepaidCardLock(request: PrepaidCardLockRequest) -> AnyPublisher<PrepaidCardLockResponse, CustomError>
    func cardLock(request: CardLockRequest) -> AnyPublisher<CardLockResponse, CustomError>
    func changeCardOnlineShoppingStatus(request: ChangeCardOnlineShoppingStatusRequest) -> AnyPublisher<ChangeCardOnlineShoppingStatusResponse, CustomError>
}

class CardUseCase: CardUseCaseProtocol {
    private let cardRepository: CardRepository
    
    init(cardRepository: CardRepository) {
        self.cardRepository = cardRepository
    }
    
    func activation(request: CardActivationRequest) -> AnyPublisher<CardActivationResponse, CustomError> {
        return cardRepository.activation(request: request)
    }
    
    func status(request: CardStatusRequest) -> AnyPublisher<CardStatusResponse, CustomError> {
        return cardRepository.status(request: request)
    }
    
    func onlineShoppingStatus(request: CardOnlineShoppingStatusRequest) -> AnyPublisher<CardOnlineShoppingStatusResponse, CustomError> {
        return cardRepository.onlineShoppingStatus(request: request)
    }
    
    func prepaidCardLock(request: PrepaidCardLockRequest) -> AnyPublisher<PrepaidCardLockResponse, CustomError> {
        return cardRepository.prepaidCardLock(request: request)
    }
    
    func cardLock(request: CardLockRequest) -> AnyPublisher<CardLockResponse, CustomError> {
        return cardRepository.lock(request: request)
    }
    
    func changeCardOnlineShoppingStatus(request: ChangeCardOnlineShoppingStatusRequest) -> AnyPublisher<ChangeCardOnlineShoppingStatusResponse, CustomError> {
        return cardRepository.changeCardOnlineShoppingStatus(request: request)
    }
}
