//
//  OTPDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Combine

class OTPDataRepository: OTPRepository {
    func send(request: SendOTPRequest) -> AnyPublisher<SendOTPEntity, Error> {
        return APIClient.callAPI(route: .sendOTP, method: .post, request: request, showLoading: true)
    }
    
    func validate(request: ValidateOTPRequest) -> AnyPublisher<ValidateOTPEntity, Error> {
        return APIClient.callAPI(route: .validateOTP, method: .post, request: request, showLoading: true)
    }
}
