//
//  UserDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/06/23.
//

import Combine

class UserDataRepository: UserRepository {
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, APIError> {
        return APIClient.callAPI(route: .login, method: .post, request: request)
    }
    
    func userRegister(request: UserRegisterRequest) -> AnyPublisher<UserRegisterResponse, APIError> {
        return APIClient.callAPI(route: .userRegister, method: .post, request: request)
    }
    
    func validatePersonalData(request: ValidatePersonalDataRequest) -> AnyPublisher<ValidatePersonaDataResponse, APIError> {
        return APIClient.callAPI(route: .validatePersonalData, method: .post, request: request)
    }
    
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationResponse, APIError> {
        return APIClient.callAPI(route: .validateAffiliation, method: .post, request: request)
    }
    
    func data(request: ConsultUserDataRequest) -> AnyPublisher<ConsultUserDataResponse, APIError> {
        return APIClient.callAPI(route: .consultUserData, method: .post, request: request)
    }
    
    func updateUsername(request: UpdateUsernameRequest) -> AnyPublisher<UpdateUsernameResponse, APIError> {
        return APIClient.callAPI(route: .updateUsername, method: .post, request: request)
    }
    
    func updateEmail(request: UpdateEmailRequest) -> AnyPublisher<UpdateEmailResponse, APIError> {
        return APIClient.callAPI(route: .updateEmail, method: .post, request: request)
    }
    
    func updatePassword(request: UpdatePasswordRequest) -> AnyPublisher<UpdatePasswordResponse, APIError> {
        return APIClient.callAPI(route: .updatePassword, method: .post, request: request)
    }
    
    func existsUser(request: ExistsUserRequest) -> AnyPublisher<ExistsUserResponse, APIError> {
        return APIClient.callAPI(route: .existsUser, method: .post, request: request)
    }
    
    func createNewPassword(request: NewPasswordRequest) -> AnyPublisher<NewPasswordResponse, APIError> {
        return APIClient.callAPI(route: .recoverPassword, method: .post, request: request)
    }
    
    func userRecovery(request: UserRecoveryRequest) -> AnyPublisher<UserRecoveryResponse, APIError> {
        return APIClient.callAPI(route: .userRecovery, method: .post, request: request)
    }
}
