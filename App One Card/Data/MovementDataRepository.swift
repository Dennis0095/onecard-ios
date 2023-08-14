//
//  MovementDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 3/07/23.
//

import Combine

class MovementDataRepository: MovementRepository {
    func paginate(request: MovementsHistoryRequest) -> AnyPublisher<MovementsHistoryResponse, CustomError> {
        return APIClient.callAPI(route: .movementsHistory, method: .post, request: request)
    }
    
    func consult(request: ConsultMovementsRequest) -> AnyPublisher<ConsultMovementsResponse, CustomError> {
        return APIClient.callAPI(route: .consultMovements, method: .post, request: request)
    }
}
