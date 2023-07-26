//
//  OTPUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Combine

protocol OTPUseCaseProtocol {
    func send(request: SendOTPRequest) -> AnyPublisher<SendOTPResponse, Error>
    func validate(request: ValidateOTPRequest) -> AnyPublisher<ValidateOTPResponse, Error>
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
    
    func send(request: SendOTPRequest) -> AnyPublisher<SendOTPResponse, Error> {
        return otpRepository.send(request: request)
    }
    
    func validate(request: ValidateOTPRequest) -> AnyPublisher<ValidateOTPResponse, Error> {
        return otpRepository.validate(request: request)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
