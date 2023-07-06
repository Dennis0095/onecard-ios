//
//  ExampleRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 24/06/23.
//

import Combine

protocol UserRepository {
    func validateAffiliation(request: ValidateAffiliationRequest) -> AnyPublisher<ValidateAffiliationEntity, Error>
    func validatePersonalData(request: ValidatePersonalDataRequest) -> AnyPublisher<ValidatePersonaDataEntity, Error>
    func userRegister(request: UserRegisterRequest) -> AnyPublisher<UserRegisterEntity, Error>
}