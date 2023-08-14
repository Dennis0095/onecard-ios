//
//  MovementRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 3/07/23.
//

import Combine

protocol MovementRepository {
    func consult(request: ConsultMovementsRequest) -> AnyPublisher<ConsultMovementsResponse, CustomError>
    func paginate(request: MovementsHistoryRequest) -> AnyPublisher<MovementsHistoryResponse, CustomError>
}
