//
//  ExampleRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 24/06/23.
//

import Combine

protocol UserRepository {
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
