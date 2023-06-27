//
//  ExampleRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 24/06/23.
//

import Foundation
import Combine

protocol ExampleRepository {
    //func validateUser(completion: @escaping (Result<ExampleEntity, Error>) -> Void)
    func validateUser() -> AnyPublisher<ExampleEntity, Error>
}
