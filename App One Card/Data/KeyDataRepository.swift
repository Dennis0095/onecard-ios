//
//  KeyDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

class KeyDataRepository: KeyRepository {
    func reassign(request: ValidateKeyRequest) -> AnyPublisher<ReassignKeyResponse, CustomError> {
        return APIClient.callAPI(route: .reassignKey, method: .post, request: request)
    }
    
    func validate(request: ValidateKeyRequest) -> AnyPublisher<ValidateKeyResponse, CustomError> {
        return APIClient.callAPI(route: .validateKey, method: .post, request: request)
    }
}
