//
//  ExampleUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 24/06/23.
//

import Combine

protocol UserUseCaseProtocol {
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, CustomError>
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationResponse, CustomError>
    func validatePersonalData(request: ValidatePersonalDataRequest) -> AnyPublisher<ValidatePersonaDataResponse, CustomError>
    func userRegister(request: UserRegisterRequest) -> AnyPublisher<UserRegisterResponse, CustomError>
    func data(request: ConsultUserDataRequest) -> AnyPublisher<ConsultUserDataResponse, CustomError>
    func updateUsername(request: UpdateUsernameRequest) -> AnyPublisher<UpdateUsernameResponse, CustomError>
    func updateEmail(request: UpdateEmailRequest) -> AnyPublisher<UpdateEmailResponse, CustomError>
    func updatePassword(request: UpdatePasswordRequest) -> AnyPublisher<UpdatePasswordResponse, CustomError>
}

class UserUseCase: UserUseCaseProtocol {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, CustomError> {
        return userRepository.login(request: request)
    }
    
    func userRegister(request: UserRegisterRequest) -> AnyPublisher<UserRegisterResponse, CustomError> {
        return userRepository.userRegister(request: request)
    }
    
    func validatePersonalData(request: ValidatePersonalDataRequest) -> AnyPublisher<ValidatePersonaDataResponse, CustomError> {
        return userRepository.validatePersonalData(request: request)
    }
    
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationResponse, CustomError> {
        return userRepository.validateAffiliation(request: request)
    }
    
    func data(request: ConsultUserDataRequest) -> AnyPublisher<ConsultUserDataResponse, CustomError> {
        return userRepository.data(request: request)
    }
    
    func updateUsername(request: UpdateUsernameRequest) -> AnyPublisher<UpdateUsernameResponse, CustomError> {
        return userRepository.updateUsername(request: request)
    }
    
    func updateEmail(request: UpdateEmailRequest) -> AnyPublisher<UpdateEmailResponse, CustomError> {
        return userRepository.updateEmail(request: request)
    }
    
    func updatePassword(request: UpdatePasswordRequest) -> AnyPublisher<UpdatePasswordResponse, CustomError> {
        return userRepository.updatePassword(request: request)
    }
}
