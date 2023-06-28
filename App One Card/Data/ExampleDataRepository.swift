//
//  ExampleDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/06/23.
//

import Combine

class UserDataRepository: UserRepository {
    func validatePersonalData(request: ValidatePersonalDataRequest) -> AnyPublisher<ValidatePersonaDataEntity, Error> {
        return APIClient.callAPI(route: .validatePersonalData, method: .post, request: request, showLoading: true)
    }
    
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationEntity, Error> {
        return APIClient.callAPI(route: .validateAffiliation, method: .post, request: request, showLoading: true)
    }
}
