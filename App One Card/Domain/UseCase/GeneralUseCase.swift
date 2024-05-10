//
//  GeneralUseCase.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 9/05/24.
//

import Foundation
import Combine

protocol GeneralUseCaseProtocol {
    func getParameters() -> AnyPublisher<GeneralParametersResponse, APIError>
}

class GeneralUseCase: GeneralUseCaseProtocol {
    private let repository: GeneralRepository
    
    init(repository: GeneralRepository) {
        self.repository = repository
    }
    
    func getParameters() -> AnyPublisher<GeneralParametersResponse, APIError> {
        return repository.getParameters()
    }
}
