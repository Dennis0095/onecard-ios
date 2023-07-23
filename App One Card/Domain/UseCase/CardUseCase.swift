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
    
//    func activation(request: CardActivationRequest, completion: @escaping (Result<CardActivationResponse, CustomError>) -> Void) {
//        let cancellable = cardRepository.activation(request: request)
//            .sink { publisher in
//                switch publisher {
//                case .finished: break
//                case .failure(let error):
//                    let error = CustomError(title: "Error", description: error.localizedDescription)
//                    completion(.failure(error))
//                }
//            } receiveValue: { response in
//                completion(.success(response))
//            }
//
//        cancellable.store(in: &cancellables)
//    }
    
    func status(request: CardStatusRequest) -> AnyPublisher<CardStatusResponse, Error> {
        return cardRepository.status(request: request)
    }
    
    func onlineShoppingStatus(request: CardOnlineShoppingStatusRequest) -> AnyPublisher<CardOnlineShoppingStatusResponse, Error> {
        return cardRepository.onlineShoppingStatus(request: request)
    }
    
    func temporaryLock(request: TemporaryCardLockRequest) -> AnyPublisher<TemporaryCardLockResponse, Error> {
        return cardRepository.temporaryLock(request: request)
    }
    
    func changeCardOnlineShoppingStatus(request: ChangeCardOnlineShoppingStatusRequest) -> AnyPublisher<ChangeCardOnlineShoppingStatusResponse, Error> {
        return cardRepository.changeCardOnlineShoppingStatus(request: request)
    }
}
