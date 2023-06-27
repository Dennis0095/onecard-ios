//
//  ExampleUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 24/06/23.
//

import Foundation
import Combine

protocol ExampleUseCaseProtocol {
    //func validateUser(completion: @escaping (Result<ExampleEntity, Error>) -> Void)
    func validateUser() -> AnyPublisher<ExampleEntity, Error>
}

class ExampleUseCase: ExampleUseCaseProtocol {
    private let exampleRepository: ExampleRepository
    
    init(exampleRepository: ExampleRepository) {
        self.exampleRepository = exampleRepository
    }
    
//    func validateUser(completion: @escaping (Result<ExampleEntity, Error>) -> Void) {
//        exampleRepository.validateUser(completion: completion)
//    }
    
    func validateUser() -> AnyPublisher<ExampleEntity, Error> {
        return exampleRepository.validateUser()
    }
}
