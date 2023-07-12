//
//  CardUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

protocol CardUseCaseProtocol {
    func activation(request: CardActivationRequest, completion: @escaping (Result<CardActivationResponse, CustomError>) -> Void)
}

class CardUseCase: CardUseCaseProtocol {
    private let cardRepository: CardRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(cardRepository: CardRepository) {
        self.cardRepository = cardRepository
    }
    
    deinit {
       cancelRequests()
    }
    
    func activation(request: CardActivationRequest, completion: @escaping (Result<CardActivationResponse, CustomError>) -> Void) {
        let cancellable = cardRepository.activation(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    let error = CustomError(title: "Error", description: error.localizedDescription)
                    completion(.failure(error))
                }
            } receiveValue: { response in
                completion(.success(response))
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
