//
//  OTPUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Combine

protocol OTPUseCaseProtocol {
    func sendToRegister(request: SendOTPRegisterRequest) -> AnyPublisher<SendOTPRegisterResponse, CustomError>
    func validateToRegister(request: ValidateOTPRegisterRequest) -> AnyPublisher<ValidateOTPResponse, CustomError>
    func sendToUpdate(request: SendOTPUpdateRequest) -> AnyPublisher<SendOTPUpdateResponse, CustomError>
    func validateToUpdate(request: ValidateOTPUpdateRequest) -> AnyPublisher<ValidateOTPResponse, CustomError>
}

class OTPUseCase: OTPUseCaseProtocol {
    private let otpRepository: OTPRepository
    
    init(otpRepository: OTPRepository) {
        self.otpRepository = otpRepository
    }
    
    func sendToRegister(request: SendOTPRegisterRequest) -> AnyPublisher<SendOTPRegisterResponse, CustomError> {
        return otpRepository.sendToRegister(request: request)
    }
    
    func validateToRegister(request: ValidateOTPRegisterRequest) -> AnyPublisher<ValidateOTPResponse, CustomError> {
        return otpRepository.validateToRegister(request: request)
    }
    
    func sendToUpdate(request: SendOTPUpdateRequest) -> AnyPublisher<SendOTPUpdateResponse, CustomError> {
        return otpRepository.sendToUpdate(request: request)
    }
    
    func validateToUpdate(request: ValidateOTPUpdateRequest) -> AnyPublisher<ValidateOTPResponse, CustomError> {
        return otpRepository.validateToUpdate(request: request)
    }
}
