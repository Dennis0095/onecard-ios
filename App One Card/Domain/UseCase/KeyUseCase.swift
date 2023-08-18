//
//  KeyUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

protocol KeyUseCaseProtocol {
    func reassign(request: ReassignKeyRequest) -> AnyPublisher<ReassignKeyResponse, APIError>
    func validate(request: ValidateKeyRequest) -> AnyPublisher<ValidateKeyResponse, APIError>
}

class KeyUseCase: KeyUseCaseProtocol {
    private let keyRepository: KeyRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(keyRepository: KeyRepository) {
        self.keyRepository = keyRepository
    }
    
    func validate(request: ValidateKeyRequest) -> AnyPublisher<ValidateKeyResponse, APIError> {
        return keyRepository.validate(request: request)
    }
    
    func reassign(request: ReassignKeyRequest) -> AnyPublisher<ReassignKeyResponse, APIError> {
        return keyRepository.reassign(request: request)
    }
}
