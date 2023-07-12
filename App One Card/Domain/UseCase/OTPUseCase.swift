//
//  OTPUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Combine

protocol OTPUseCaseProtocol {
    func send(request: SendOTPRequest, completion: @escaping (Result<SendOTPResponse, CustomError>) -> Void)
    func validate(request: ValidateOTPRequest, completion: @escaping (Result<ValidateOTPResponse, CustomError>) -> Void)
}

class OTPUseCase: OTPUseCaseProtocol {
    private let otpRepository: OTPRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(otpRepository: OTPRepository) {
        self.otpRepository = otpRepository
    }
    
    deinit {
       cancelRequests()
    }
    
    func send(request: SendOTPRequest, completion: @escaping (Result<SendOTPResponse, CustomError>) -> Void) {
        let cancellable = otpRepository.send(request: request)
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
    
    func validate(request: ValidateOTPRequest, completion: @escaping (Result<ValidateOTPResponse, CustomError>) -> Void) {
        let cancellable = otpRepository.validate(request: request)
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
                
                if response.indexMatchOTP == "1" {
                    completion(.success(response))
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
