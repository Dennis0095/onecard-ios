//
//  CardRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

protocol CardRepository {
    func activation(request: CardActivationRequest) -> AnyPublisher<CardActivationResponse, Error>
    func status(request: CardStatusRequest) -> AnyPublisher<CardStatusResponse, Error>
    func onlineShoppingStatus(request: CardOnlineShoppingStatusRequest) -> AnyPublisher<CardOnlineShoppingStatusResponse, Error>
    func temporaryLock(request: TemporaryCardLockRequest) -> AnyPublisher<TemporaryCardLockResponse, Error>
    func lock(request: CardLockRequest) -> AnyPublisher<CardLockResponse, Error>
    func changeCardOnlineShoppingStatus(request: ChangeCardOnlineShoppingStatusRequest) -> AnyPublisher<ChangeCardOnlineShoppingStatusResponse, Error>
}
