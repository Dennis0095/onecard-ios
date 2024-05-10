//
//  LogoutUseCase.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 9/05/24.
//

import Foundation
import Combine

protocol LogoutUseCaseProtocol {
    func logout(request: BaseRequest) -> AnyPublisher<LogoutResponse, APIError>
}

class LogoutUseCase: LogoutUseCaseProtocol {
    private let repository: LogoutRepository
    
    init(repository: LogoutRepository) {
        self.repository = repository
    }
    
    func logout(request: BaseRequest) -> AnyPublisher<LogoutResponse, APIError> {
        return repository.logout(request: request)
    }
}
