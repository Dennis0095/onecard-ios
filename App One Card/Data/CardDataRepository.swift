//
//  CardDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

class CardDataRepository: CardRepository {
    func activation(request: CardActivationRequest) -> AnyPublisher<CardActivationResponse, Error> {
        return APIClient.callAPI(route: .cardActivation, method: .post, request: request)
    }
    
    func status(request: CardStatusRequest) -> AnyPublisher<CardStatusResponse, Error> {
        return APIClient.callAPI(route: .cardStatus, method: .post, request: request)
    }
    
    func onlineShoppingStatus(request: CardOnlineShoppingStatusRequest) -> AnyPublisher<CardOnlineShoppingStatusResponse, Error> {
        return APIClient.callAPI(route: .cardOnlineShoppingStatus, method: .post, request: request)
    }
    
    func temporaryLock(request: TemporaryCardLockRequest) -> AnyPublisher<TemporaryCardLockResponse, Error> {
        return APIClient.callAPI(route: .cardLock, method: .post, request: request)
    }
    
    func changeCardOnlineShoppingStatus(request: ChangeCardOnlineShoppingStatusRequest) -> AnyPublisher<ChangeCardOnlineShoppingStatusResponse, Error> {
        return APIClient.callAPI(route: .changeCardOnlineShoppingStatus, method: .post, request: request)
    }
    
    func statusMock() -> AnyPublisher<CardStatusResponse, Error> {
        return APIClient.callAPI(baseUrl: "https://demo7545010.mockable.io/statusCard", route: .without, method: .get)
    }
}

struct VoidResponse: Codable {}
