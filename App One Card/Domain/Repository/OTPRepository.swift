//
//  OTPRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Combine

protocol OTPRepository {
    func sendToRegister(request: SendOTPRegisterRequest) -> AnyPublisher<SendOTPRegisterResponse, Error>
    func validateToRegister(request: ValidateOTPRegisterRequest) -> AnyPublisher<ValidateOTPResponse, Error>
    func sendToUpdate(request: SendOTPUpdateRequest) -> AnyPublisher<SendOTPUpdateResponse, Error>
    func validateToUpdate(request: ValidateOTPUpdateRequest) -> AnyPublisher<ValidateOTPResponse, Error>
}
