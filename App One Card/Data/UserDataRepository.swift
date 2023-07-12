//
//  UserDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/06/23.
//

import Combine

class UserDataRepository: UserRepository {
    func userRegister(request: UserRegisterRequest) -> AnyPublisher<UserRegisterResponse, Error> {
        return APIClient.callAPI(route: .userRegister, method: .post, request: request, showLoading: true)
    }
    
    func validatePersonalData(request: ValidatePersonalDataRequest) -> AnyPublisher<ValidatePersonaDataResponse, Error> {
        return APIClient.callAPI(route: .validatePersonalData, method: .post, request: request, showLoading: true)
    }
    
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationResponse, Error> {
        return APIClient.callAPI(route: .validateAffiliation, method: .post, request: request, showLoading: true)
    }
}
