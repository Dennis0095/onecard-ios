//
//  OTPUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Combine

protocol OTPUseCaseProtocol {
    func sendToRegister(request: SendOTPRegisterRequest) -> AnyPublisher<SendOTPRegisterResponse, Error>
    func validateToRegister(request: ValidateOTPRegisterRequest) -> AnyPublisher<ValidateOTPResponse, Error>
    func sendToUpdate(request: SendOTPUpdateRequest) -> AnyPublisher<SendOTPUpdateResponse, Error>
    func validateToUpdate(request: ValidateOTPUpdateRequest) -> AnyPublisher<ValidateOTPResponse, Error>
}

class OTPUseCase: OTPUseCaseProtocol {
    private let otpRepository: OTPRepository
    
    init(otpRepository: OTPRepository) {
        self.otpRepository = otpRepository
    }
    
    func sendToRegister(request: SendOTPRegisterRequest) -> AnyPublisher<SendOTPRegisterResponse, Error> {
        return otpRepository.sendToRegister(request: request)
    }
    
    func validateToRegister(request: ValidateOTPRegisterRequest) -> AnyPublisher<ValidateOTPResponse, Error> {
        return otpRepository.validateToRegister(request: request)
    }
    
    func sendToUpdate(request: SendOTPUpdateRequest) -> AnyPublisher<SendOTPUpdateResponse, Error> {
        return otpRepository.sendToUpdate(request: request)
    }
    
    func validateToUpdate(request: ValidateOTPUpdateRequest) -> AnyPublisher<ValidateOTPResponse, Error> {
        return otpRepository.validateToUpdate(request: request)
    }
}
