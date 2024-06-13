//
//  CardRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

protocol CardRepository {
    func activation(request: CardActivationRequest) -> AnyPublisher<CardActivationResponse, APIError>
    func status(request: CardStatusRequest) -> AnyPublisher<CardStatusResponse, APIError>
    func onlineShoppingStatus(request: CardOnlineShoppingStatusRequest) -> AnyPublisher<CardOnlineShoppingStatusResponse, APIError>
    func prepaidCardLock(request: PrepaidCardLockRequest) -> AnyPublisher<PrepaidCardLockResponse, APIError>
    func lock(request: CardLockRequest) -> AnyPublisher<CardLockResponse, APIError>
    func changeCardOnlineShoppingStatus(request: ChangeCardOnlineShoppingStatusRequest) -> AnyPublisher<ChangeCardOnlineShoppingStatusResponse, APIError>
}
