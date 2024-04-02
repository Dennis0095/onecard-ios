//
//  BannersUseCase.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 6/03/24.
//

import Combine

protocol BannersUseCaseProtocol {
    func consult(request: ConsultBannersRequest) -> AnyPublisher<ConsultBannersResponse, APIError>
}

class BannersUseCase: BannersUseCaseProtocol {
    
    private let bannersRepository: BannersRepository
    
    init(bannersRepository: BannersRepository) {
        self.bannersRepository = bannersRepository
    }
    
    func consult(request: ConsultBannersRequest) -> AnyPublisher<ConsultBannersResponse, APIError> {
        return bannersRepository.consult(request: request)
    }
}


