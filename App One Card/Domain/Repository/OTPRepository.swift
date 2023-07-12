//
//  OTPRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Combine

protocol OTPRepository {
    func send(request: SendOTPRequest) -> AnyPublisher<SendOTPResponse, Error>
    func validate(request: ValidateOTPRequest) -> AnyPublisher<ValidateOTPResponse, Error>
}
