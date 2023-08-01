//
//  ExampleRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 24/06/23.
//

import Combine

protocol UserRepository {
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, CustomError>
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationResponse, CustomError>
    func validatePersonalData(request: ValidatePersonalDataRequest) -> AnyPublisher<ValidatePersonaDataResponse, CustomError>
    func userRegister(request: UserRegisterRequest) -> AnyPublisher<UserRegisterResponse, CustomError>
    func data(request: ConsultUserDataRequest) -> AnyPublisher<ConsultUserDataResponse, CustomError>
    func updateUsername(request: UpdateUsernameRequest) -> AnyPublisher<UpdateUsernameResponse, CustomError>
    func updateEmail(request: UpdateEmailRequest) -> AnyPublisher<UpdateEmailResponse, CustomError>
    func updatePassword(request: UpdatePasswordRequest) -> AnyPublisher<UpdatePasswordResponse, CustomError>
}
