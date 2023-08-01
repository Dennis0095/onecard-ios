//
//  MovementUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 3/07/23.
//

import Combine

protocol MovementUseCaseProtocol {
    func consult(request: ConsultMovementsRequest) -> AnyPublisher<ConsultMovementsResponse, Error>
}

class MovementUseCase: MovementUseCaseProtocol {
    private let movementRepository: MovementRepository
    
    init(movementRepository: MovementRepository) {
        self.movementRepository = movementRepository
    }
    
    func consult(request: ConsultMovementsRequest) -> AnyPublisher<ConsultMovementsResponse, Error> {
        return movementRepository.consult(request: request)
    }
}

