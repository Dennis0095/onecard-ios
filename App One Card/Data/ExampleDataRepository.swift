//
//  ExampleDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/06/23.
//

import Foundation
import Combine

class ExampleDataRepository: ExampleRepository {
    func validateUser() -> AnyPublisher<ExampleEntity, Error> {
        return APIClient.callAPI2(route: .validateUser, method: .get, showLoading: true)
    }
    
//    func validateUser(completion: @escaping (Result<ExampleEntity, Error>) -> Void) {
//        APIClient.callAPI(route: .validateUser, method: .get, completion: completion)
//    }
}
