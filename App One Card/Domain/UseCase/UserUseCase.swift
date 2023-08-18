//
//  ExampleUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 24/06/23.
//

import Combine

protocol UserUseCaseProtocol {
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, APIError>
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationResponse, APIError>
    func validatePersonalData(request: ValidatePersonalDataRequest) -> AnyPublisher<ValidatePersonaDataResponse, APIError>
    func userRegister(request: UserRegisterRequest) -> AnyPublisher<UserRegisterResponse, APIError>
    func data(request: ConsultUserDataRequest) -> AnyPublisher<ConsultUserDataResponse, APIError>
    func updateUsername(request: UpdateUsernameRequest) -> AnyPublisher<UpdateUsernameResponse, APIError>
    func updateEmail(request: UpdateEmailRequest) -> AnyPublisher<UpdateEmailResponse, APIError>
    func updatePassword(request: UpdatePasswordRequest) -> AnyPublisher<UpdatePasswordResponse, APIError>
    func existsUser(request: ExistsUserRequest) -> AnyPublisher<ExistsUserResponse, APIError>
    func createNewPassword(request: NewPasswordRequest) -> AnyPublisher<NewPasswordResponse, APIError>
}

class UserUseCase: UserUseCaseProtocol {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, APIError> {
        return userRepository.login(request: request)
    }
    
    func userRegister(request: UserRegisterRequest) -> AnyPublisher<UserRegisterResponse, APIError> {
        return userRepository.userRegister(request: request)
    }
    
    func validatePersonalData(request: ValidatePersonalDataRequest) -> AnyPublisher<ValidatePersonaDataResponse, APIError> {
        return userRepository.validatePersonalData(request: request)
    }
    
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationResponse, APIError> {
        return userRepository.validateAffiliation(request: request)
    }
    
    func data(request: ConsultUserDataRequest) -> AnyPublisher<ConsultUserDataResponse, APIError> {
        return userRepository.data(request: request)
    }
    
    func updateUsername(request: UpdateUsernameRequest) -> AnyPublisher<UpdateUsernameResponse, APIError> {
        return userRepository.updateUsername(request: request)
    }
    
    func updateEmail(request: UpdateEmailRequest) -> AnyPublisher<UpdateEmailResponse, APIError> {
        return userRepository.updateEmail(request: request)
    }
    
    func updatePassword(request: UpdatePasswordRequest) -> AnyPublisher<UpdatePasswordResponse, APIError> {
        return userRepository.updatePassword(request: request)
    }
    
    func existsUser(request: ExistsUserRequest) -> AnyPublisher<ExistsUserResponse, APIError> {
        return userRepository.existsUser(request: request)
    }
    
    func createNewPassword(request: NewPasswordRequest) -> AnyPublisher<NewPasswordResponse, APIError> {
        return userRepository.createNewPassword(request: request)
    }
}
