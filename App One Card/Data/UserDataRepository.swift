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
    
    func updateUsername(request: UpdateUsernameRequest) -> AnyPublisher<UpdateUsernameResponse, Error> {
        return APIClient.callAPI(route: .updateUsername, method: .post, request: request)
    }
    
    func updateEmail(request: UpdateEmailRequest) -> AnyPublisher<UpdateEmailResponse, Error> {
        return APIClient.callAPI(route: .updateEmail, method: .post, request: request)
    }
    
    func updatePassword(request: UpdatePasswordRequest) -> AnyPublisher<UpdatePasswordResponse, Error> {
        return APIClient.callAPI(route: .updatePassword, method: .post, request: request)
    }
}
