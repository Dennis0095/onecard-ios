//
//  CardDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

class CardDataRepository: CardRepository {
    func activation(request: CardActivationRequest) -> AnyPublisher<CardActivationResponse, APIError> {
        return APIClient.callAPI(route: .cardActivation, method: .post, request: request)
    }
    
    func status(request: CardStatusRequest) -> AnyPublisher<CardStatusResponse, APIError> {
        return APIClient.callAPI(route: .cardStatus, method: .post, request: request)
    }
    
    func onlineShoppingStatus(request: CardOnlineShoppingStatusRequest) -> AnyPublisher<CardOnlineShoppingStatusResponse, APIError> {
        return APIClient.callAPI(route: .cardOnlineShoppingStatus, method: .post, request: request)
    }
    
    func prepaidCardLock(request: PrepaidCardLockRequest) -> AnyPublisher<PrepaidCardLockResponse, APIError> {
        return APIClient.callAPI(route: .prepaidCardLock, method: .post, request: request)
    }
    
    func changeCardOnlineShoppingStatus(request: ChangeCardOnlineShoppingStatusRequest) -> AnyPublisher<ChangeCardOnlineShoppingStatusResponse, APIError> {
        return APIClient.callAPI(route: .changeCardOnlineShoppingStatus, method: .post, request: request)
    }
    
    func lock(request: CardLockRequest) -> AnyPublisher<CardLockResponse, APIError> {
        return APIClient.callAPI(route: .cardLock, method: .post, request: request)
    }
}
