//
//  KeyRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

protocol KeyRepository {
    func reassign(request: ReassignKeyRequest) -> AnyPublisher<ReassignKeyResponse, APIError>
    func validate(request: ValidateKeyRequest) -> AnyPublisher<ValidateKeyResponse, APIError>
}
