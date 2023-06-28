//
//  ExampleUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 24/06/23.
//

import Foundation
import Combine

protocol UserUseCaseProtocol {
    func validateUser(request: ValidateAffiliationRequest, completion: @escaping (Result<ValidateAffiliationEntity, CustomError>) -> Void)
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
    
    func validateUser(request: ValidateAffiliationRequest, completion: @escaping (Result<ValidateAffiliationEntity, CustomError>) -> Void) {
        //return userRepository.validateAffiliation(request: request)
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
