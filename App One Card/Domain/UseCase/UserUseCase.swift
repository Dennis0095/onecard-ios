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
    func userRegister(request: UserRegisterRequest, completion: @escaping (Result<UserRegisterResponse, CustomError>) -> Void)
    func data(request: ConsultUserDataRequest) -> AnyPublisher<ConsultUserDataResponse, Error>
}

class UserUseCase: UserUseCaseProtocol {
    private let userRepository: UserRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    deinit {
       cancelRequests()
    }
    
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, Error> {
        return userRepository.login(request: request)
    }
    
    func userRegister(request: UserRegisterRequest, completion: @escaping (Result<UserRegisterResponse, CustomError>) -> Void) {
        let cancellable = userRepository.userRegister(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    let error = CustomError(title: "Error", description: error.localizedDescription)
                    completion(.failure(error))
                }
            } receiveValue: { response in
                let title = response.title ?? ""
                let description = response.message ?? ""
                
                if response.validExpiration == "1" {
                    if response.validUser == "1" && response.validPassword == "1" {
                        completion(.success(response))
                    } else {
                        if response.confirmPassword == "1" {
                            if response.userExists == "0" {
                                completion(.success(response))
                            } else {
                                let error = CustomError(title: title, description: description)
                                completion(.failure(error))
                            }
                        } else {
                            let error = CustomError(title: title, description: description)
                            completion(.failure(error))
                        }
                    }
                } else {
                    let error = CustomError(title: title, description: description, timeExpired: true)
                    completion(.failure(error))
                }
            }
        
        cancellable.store(in: &cancellables)
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
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
