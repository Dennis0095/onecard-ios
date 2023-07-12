//
//  KeyRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

protocol KeyRepository {
    func reassign(request: ValidateKeyRequest) -> AnyPublisher<ReassignKeyResponse, Error>
    func validate(request: ValidateKeyRequest) -> AnyPublisher<ValidateKeyResponse, Error>
}
