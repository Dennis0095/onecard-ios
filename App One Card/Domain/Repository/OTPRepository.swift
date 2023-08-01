//
//  OTPRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Combine

protocol OTPRepository {
    func sendToRegister(request: SendOTPRegisterRequest) -> AnyPublisher<SendOTPRegisterResponse, CustomError>
    func validateToRegister(request: ValidateOTPRegisterRequest) -> AnyPublisher<ValidateOTPResponse, CustomError>
    func sendToUpdate(request: SendOTPUpdateRequest) -> AnyPublisher<SendOTPUpdateResponse, CustomError>
    func validateToUpdate(request: ValidateOTPUpdateRequest) -> AnyPublisher<ValidateOTPResponse, CustomError>
}
