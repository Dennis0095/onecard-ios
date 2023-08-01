//
//  ExampleUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 24/06/23.
//

import Combine

protocol UserUseCaseProtocol {
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, Error>
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationResponse, Error>
    func validatePersonalData(request: ValidatePersonalDataRequest) -> AnyPublisher<ValidatePersonaDataResponse, Error>
    func userRegister(request: UserRegisterRequest) -> AnyPublisher<UserRegisterResponse, Error>
    func data(request: ConsultUserDataRequest) -> AnyPublisher<ConsultUserDataResponse, Error>
    func updateUsername(request: UpdateUsernameRequest) -> AnyPublisher<UpdateUsernameResponse, Error>
    func updateEmail(request: UpdateEmailRequest) -> AnyPublisher<UpdateEmailResponse, Error>
    func updatePassword(request: UpdatePasswordRequest) -> AnyPublisher<UpdatePasswordResponse, Error>
}

class UserUseCase: UserUseCaseProtocol {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, Error> {
        return userRepository.login(request: request)
    }
    
    func userRegister(request: UserRegisterRequest) -> AnyPublisher<UserRegisterResponse, Error> {
        return userRepository.userRegister(request: request)
    }
    
    func validatePersonalData(request: ValidatePersonalDataRequest) -> AnyPublisher<ValidatePersonaDataResponse, Error> {
        return userRepository.validatePersonalData(request: request)
    }
    
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationResponse, Error> {
        return userRepository.validateAffiliation(request: request)
    }
    
    func data(request: ConsultUserDataRequest) -> AnyPublisher<ConsultUserDataResponse, Error> {
        return userRepository.data(request: request)
    }
    
    func updateUsername(request: UpdateUsernameRequest) -> AnyPublisher<UpdateUsernameResponse, Error> {
        return userRepository.updateUsername(request: request)
    }
    
    func updateEmail(request: UpdateEmailRequest) -> AnyPublisher<UpdateEmailResponse, Error> {
        return userRepository.updateEmail(request: request)
    }
    
    func updatePassword(request: UpdatePasswordRequest) -> AnyPublisher<UpdatePasswordResponse, Error> {
        return userRepository.updatePassword(request: request)
    }
}
