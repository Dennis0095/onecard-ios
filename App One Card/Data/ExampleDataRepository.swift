//
//  ExampleDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/06/23.
//

import Combine

class UserDataRepository: UserRepository {
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationEntity, Error> {
        return APIClient.callAPI(route: .validateAffiliation, method: .post, request: request, showLoading: true)
    }
}
