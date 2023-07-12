//
//  MovementDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 3/07/23.
//

import Combine

class MovementDataRepository: MovementRepository {
    func consult(request: ConsultMovementsRequest) -> AnyPublisher<ConsultMovementsResponse, Error> {
        return APIClient.callAPI(route: .consultMovements, method: .post, request: request)
    }
}
