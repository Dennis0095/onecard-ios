//
//  UserDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 26/06/23.
//

import Combine

class UserDataRepository: UserRepository {
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, CustomError> {
        return APIClient.callAPI(route: .login, method: .post, request: request)
    }
    
    func userRegister(request: UserRegisterRequest) -> AnyPublisher<UserRegisterResponse, CustomError> {
        return APIClient.callAPI(route: .userRegister, method: .post, request: request)
    }
    
    func validatePersonalData(request: ValidatePersonalDataRequest) -> AnyPublisher<ValidatePersonaDataResponse, CustomError> {
        return APIClient.callAPI(route: .validatePersonalData, method: .post, request: request)
    }
    
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationResponse, CustomError> {
        return APIClient.callAPI(route: .validateAffiliation, method: .post, request: request)
    }
    
    func data(request: ConsultUserDataRequest) -> AnyPublisher<ConsultUserDataResponse, CustomError> {
        return APIClient.callAPI(route: .consultUserData, method: .post, request: request)
    }
    
    func updateUsername(request: UpdateUsernameRequest) -> AnyPublisher<UpdateUsernameResponse, CustomError> {
        return APIClient.callAPI(route: .updateUsername, method: .post, request: request)
    }
    
    func updateEmail(request: UpdateEmailRequest) -> AnyPublisher<UpdateEmailResponse, CustomError> {
        return APIClient.callAPI(route: .updateEmail, method: .post, request: request)
    }
    
    func updatePassword(request: UpdatePasswordRequest) -> AnyPublisher<UpdatePasswordResponse, CustomError> {
        return APIClient.callAPI(route: .updatePassword, method: .post, request: request)
    }
    
    func existsUser(request: ExistsUserRequest) -> AnyPublisher<ExistsUserResponse, CustomError> {
        return APIClient.callAPI(route: .existsUser, method: .post, request: request)
    }
    
    func createNewPassword(request: NewPasswordRequest) -> AnyPublisher<NewPasswordResponse, CustomError> {
        return APIClient.callAPI(route: .recoverPassword, method: .post, request: request)
    }
}
