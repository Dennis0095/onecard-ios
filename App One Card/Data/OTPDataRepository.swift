//
//  OTPDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Combine

class OTPDataRepository: OTPRepository {
    func send(request: SendOTPRequest) -> AnyPublisher<SendOTPResponse, Error> {
        return APIClient.callAPI(route: .sendOTP, method: .post, request: request)
    }
    
    func validate(request: ValidateOTPRequest) -> AnyPublisher<ValidateOTPResponse, Error> {
        return APIClient.callAPI(route: .validateOTP, method: .post, request: request)
    }
}
