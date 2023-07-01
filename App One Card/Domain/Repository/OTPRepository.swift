//
//  OTPRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Foundation
import Combine

protocol OTPRepository {
    func send(request: SendOTPRequest) -> AnyPublisher<SendOTPEntity, Error>
    func validate(request: ValidateOTPRequest) -> AnyPublisher<ValidateOTPEntity, Error>
}
