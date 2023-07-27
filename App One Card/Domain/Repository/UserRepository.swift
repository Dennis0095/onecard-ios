//
//  ExampleRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 24/06/23.
//

import Combine

protocol UserRepository {
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, Error>
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationResponse, Error>
    func validatePersonalData(request: ValidatePersonalDataRequest) -> AnyPublisher<ValidatePersonaDataResponse, Error>
    func userRegister(request: UserRegisterRequest) -> AnyPublisher<UserRegisterResponse, Error>
    func data(request: ConsultUserDataRequest) -> AnyPublisher<ConsultUserDataResponse, Error>
    func updateUsername(request: UpdateUsernameRequest) -> AnyPublisher<UpdateUsernameResponse, Error>
    func updateEmail(request: UpdateEmailRequest) -> AnyPublisher<UpdateEmailResponse, Error>
}
