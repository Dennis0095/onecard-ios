//
//  KeyUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

protocol KeyUseCaseProtocol {
    func reassign(request: ReassignKeyRequest) -> AnyPublisher<ReassignKeyResponse, CustomError>
    func validate(request: ValidateKeyRequest) -> AnyPublisher<ValidateKeyResponse, CustomError>
}

class KeyUseCase: KeyUseCaseProtocol {
    private let keyRepository: KeyRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(keyRepository: KeyRepository) {
        self.keyRepository = keyRepository
    }
    
    func validate(request: ValidateKeyRequest) -> AnyPublisher<ValidateKeyResponse, CustomError> {
        return keyRepository.validate(request: request)
    }
    
    func reassign(request: ReassignKeyRequest) -> AnyPublisher<ReassignKeyResponse, CustomError> {
        return keyRepository.reassign(request: request)
    }
}
