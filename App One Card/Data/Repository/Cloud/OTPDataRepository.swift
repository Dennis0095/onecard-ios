//
//  OTPDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Combine

class OTPDataRepository: OTPRepository {
    func send(request: SendOTPRequest) -> AnyPublisher<SendOTPResponse, APIError> {
        return APIClient.callAPI(route: .sendOTP, method: .post, request: request)
    }
    
    func validateToRegister(request: ValidateOTPRegisterRequest) -> AnyPublisher<ValidateOTPResponse, APIError> {
        return APIClient.callAPI(route: .validateOTPRegister, method: .post, request: request)
    }
    
    func sendToUpdate(request: SendOTPUpdateRequest) -> AnyPublisher<SendOTPUpdateResponse, APIError> {
        return APIClient.callAPI(route: .sendOTPUpdate, method: .post, request: request)
    }
    
    func validateToUpdate(request: ValidateOTPUpdateRequest) -> AnyPublisher<ValidateOTPResponse, APIError> {
        return APIClient.callAPI(route: .validateOTPUpdate, method: .post, request: request)
    }
}
