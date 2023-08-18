//
//  MovementUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 3/07/23.
//

import Combine

protocol MovementUseCaseProtocol {
    func consult(request: ConsultMovementsRequest) -> AnyPublisher<ConsultMovementsResponse, APIError>
    func paginate(request: MovementsHistoryRequest) -> AnyPublisher<MovementsHistoryResponse, APIError>
}

class MovementUseCase: MovementUseCaseProtocol {
    private let movementRepository: MovementRepository
    
    init(movementRepository: MovementRepository) {
        self.movementRepository = movementRepository
    }
    
    func consult(request: ConsultMovementsRequest) -> AnyPublisher<ConsultMovementsResponse, APIError> {
        return movementRepository.consult(request: request)
    }
    
    func paginate(request: MovementsHistoryRequest) -> AnyPublisher<MovementsHistoryResponse, APIError> {
        return movementRepository.paginate(request: request)
    }
}

