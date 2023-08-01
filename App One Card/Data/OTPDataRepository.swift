//
//  OTPDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Combine

class OTPDataRepository: OTPRepository {
    func sendToRegister(request: SendOTPRegisterRequest) -> AnyPublisher<SendOTPRegisterResponse, CustomError> {
        return APIClient.callAPI(route: .sendOTPRegister, method: .post, request: request)
    }
    
    func validateToRegister(request: ValidateOTPRegisterRequest) -> AnyPublisher<ValidateOTPResponse, CustomError> {
        return APIClient.callAPI(route: .validateOTPRegister, method: .post, request: request)
    }
    
    func sendToUpdate(request: SendOTPUpdateRequest) -> AnyPublisher<SendOTPUpdateResponse, CustomError> {
        return APIClient.callAPI(route: .sendOTPUpdate, method: .post, request: request)
    }
    
    func validateToUpdate(request: ValidateOTPUpdateRequest) -> AnyPublisher<ValidateOTPResponse, CustomError> {
        return APIClient.callAPI(route: .validateOTPUpdate, method: .post, request: request)
    }
}
