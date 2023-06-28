//
//  ExampleUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 24/06/23.
//

import Foundation
import Combine

protocol UserUseCaseProtocol {
    func validateAffiliation(request: ValidateAffiliationRequest, completion: @escaping (Result<ValidateAffiliationEntity, CustomError>) -> Void)
    func validatePersonalData(request: ValidatePersonalDataRequest, completion: @escaping (Result<ValidatePersonaDataEntity, CustomError>) -> Void)
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
    
    func validatePersonalData(request: ValidatePersonalDataRequest, completion: @escaping (Result<ValidatePersonaDataEntity, CustomError>) -> Void) {
        let cancellable = userRepository.validatePersonalData(request: request)
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
                    if response.exists == "1" {
                        let error = CustomError(title: title, description: description)
                        completion(.failure(error))
                    } else {
                        completion(.success(response))
                    }
                } else {
                    let error = CustomError(title: title, description: description)
                    completion(.failure(error))
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func validateAffiliation(request: ValidateAffiliationRequest, completion: @escaping (Result<ValidateAffiliationEntity, CustomError>) -> Void) {
        let cancellable = userRepository.validateAffiliation(request: request)
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
                
                if response.affiliate == "1" {
                    if response.exists == "1" {
                        let error = CustomError(title: title, description: description)
                        completion(.failure(error))
                    } else {
                        completion(.success(response))
                    }
                } else {
                    let error = CustomError(title: title, description: description)
                    completion(.failure(error))
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
