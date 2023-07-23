//
//  KeyUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/07/23.
//

import Combine

protocol KeyUseCaseProtocol {
    func reassign(request: ValidateKeyRequest) -> AnyPublisher<ReassignKeyResponse, Error>
    func validate(request: ValidateKeyRequest, completion: @escaping (Result<ValidateKeyResponse, CustomError>) -> Void)
}

class KeyUseCase: KeyUseCaseProtocol {
    private let keyRepository: KeyRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(keyRepository: KeyRepository) {
        self.keyRepository = keyRepository
    }
    
    deinit {
       cancelRequests()
    }
    
    func validate(request: ValidateKeyRequest, completion: @escaping (Result<ValidateKeyResponse, CustomError>) -> Void) {
        let cancellable = keyRepository.validate(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    let error = CustomError(title: "Error", description: error.localizedDescription)
                    completion(.failure(error))
                }
            } receiveValue: { response in
                completion(.success(response))
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func reassign(request: ValidateKeyRequest) -> AnyPublisher<ReassignKeyResponse, Error> {
//        let cancellable = keyRepository.reassign(request: request)
//            .sink { publisher in
//                switch publisher {
//                case .finished: break
//                case .failure(let error):
//                    let error = CustomError(title: "Error", description: error.localizedDescription)
//                    completion(.failure(error))
//                }
//            } receiveValue: { response in
//                completion(.success(response))
//            }
//
//        cancellable.store(in: &cancellables)
        return keyRepository.reassign(request: request)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
