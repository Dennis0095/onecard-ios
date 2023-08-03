//
//  CardRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

protocol CardRepository {
    func activation(request: CardActivationRequest) -> AnyPublisher<CardActivationResponse, CustomError>
    func status(request: CardStatusRequest) -> AnyPublisher<CardStatusResponse, CustomError>
    func onlineShoppingStatus(request: CardOnlineShoppingStatusRequest) -> AnyPublisher<CardOnlineShoppingStatusResponse, CustomError>
    func prepaidCardLock(request: PrepaidCardLockRequest) -> AnyPublisher<PrepaidCardLockResponse, CustomError>
    func lock(request: CardLockRequest) -> AnyPublisher<CardLockResponse, CustomError>
    func changeCardOnlineShoppingStatus(request: ChangeCardOnlineShoppingStatusRequest) -> AnyPublisher<ChangeCardOnlineShoppingStatusResponse, CustomError>
}
