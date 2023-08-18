//
//  OTPUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Combine

protocol OTPUseCaseProtocol {
    func sendToRegister(request: SendOTPRegisterRequest) -> AnyPublisher<SendOTPRegisterResponse, APIError>
    func validateToRegister(request: ValidateOTPRegisterRequest) -> AnyPublisher<ValidateOTPResponse, APIError>
    func sendToUpdate(request: SendOTPUpdateRequest) -> AnyPublisher<SendOTPUpdateResponse, APIError>
    func validateToUpdate(request: ValidateOTPUpdateRequest) -> AnyPublisher<ValidateOTPResponse, APIError>
}

class OTPUseCase: OTPUseCaseProtocol {
    private let otpRepository: OTPRepository
    
    init(otpRepository: OTPRepository) {
        self.otpRepository = otpRepository
    }
    
    func sendToRegister(request: SendOTPRegisterRequest) -> AnyPublisher<SendOTPRegisterResponse, APIError> {
        return otpRepository.sendToRegister(request: request)
    }
    
    func validateToRegister(request: ValidateOTPRegisterRequest) -> AnyPublisher<ValidateOTPResponse, APIError> {
        return otpRepository.validateToRegister(request: request)
    }
    
    func sendToUpdate(request: SendOTPUpdateRequest) -> AnyPublisher<SendOTPUpdateResponse, APIError> {
        return otpRepository.sendToUpdate(request: request)
    }
    
    func validateToUpdate(request: ValidateOTPUpdateRequest) -> AnyPublisher<ValidateOTPResponse, APIError> {
        return otpRepository.validateToUpdate(request: request)
    }
}
