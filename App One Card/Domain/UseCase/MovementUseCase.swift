//
//  MovementUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 3/07/23.
//

import Combine

protocol MovementUseCaseProtocol {
    func consult(request: ConsultMovementsRequest, completion: @escaping (Result<ConsultMovementsResponse, CustomError>) -> Void)
}

class MovementUseCase: MovementUseCaseProtocol {
    private let movementRepository: MovementRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(movementRepository: MovementRepository) {
        self.movementRepository = movementRepository
    }
    
    deinit {
        cancelRequests()
    }
    
    func consult(request: ConsultMovementsRequest, completion: @escaping (Result<ConsultMovementsResponse, CustomError>) -> Void) {
        let cancellable = movementRepository.consult(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    let error = CustomError(title: "Error", description: error.localizedDescription)
                    completion(.failure(error))
                }
            } receiveValue: { response in
//                let description = response.description ?? ""
//
//                if response.rc == "0" {
//                    completion(.success(response))
//                } else {
//                    let error = CustomError(title: "", description: description, actionAfterFailure: true)
//                    completion(.failure(error))
//                }
                completion(.success(response))
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

