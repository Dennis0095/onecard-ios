//
//  BannersRepository.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 6/03/24.
//

import Combine

protocol BannersRepository {
    func consult(request: ConsultBannersRequest) -> AnyPublisher<ConsultBannersResponse, APIError>
}
