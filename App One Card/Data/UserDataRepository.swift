//
//  UserDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/06/23.
//

import Combine

class UserDataRepository: UserRepository {
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, Error> {
        return APIClient.callAPI(route: .login, method: .post, request: request)
    }
    
    func userRegister(request: UserRegisterRequest) -> AnyPublisher<UserRegisterResponse, Error> {
        return APIClient.callAPI(route: .userRegister, method: .post, request: request)
    }
    
    func validatePersonalData(request: ValidatePersonalDataRequest) -> AnyPublisher<ValidatePersonaDataResponse, Error> {
        return APIClient.callAPI(route: .validatePersonalData, method: .post, request: request)
    }
    
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationResponse, Error> {
        return APIClient.callAPI(route: .validateAffiliation, method: .post, request: request)
    }
    
    func data(request: ConsultUserDataRequest) -> AnyPublisher<ConsultUserDataResponse, Error> {
        return APIClient.callAPI(route: .consultUserData, method: .post, request: request)
    }
}
