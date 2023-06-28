//
//  OTPUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Foundation
import Combine

protocol OTPUseCaseProtocol {
    func send(request: SendOTPRequest) -> AnyPublisher<SendOTPEntity, Error>
    //func validate() -> AnyPublisher<ExampleEntity, Error>
}

class OTPUseCase: OTPUseCaseProtocol {
    private let otpRepository: OTPRepository
    
    init(otpRepository: OTPRepository) {
        self.otpRepository = otpRepository
    }
    
    func send(request: SendOTPRequest) -> AnyPublisher<SendOTPEntity, Error> {
        return otpRepository.send(request: request)
    }
    
//    func validate() -> AnyPublisher<ExampleEntity, Error> {
//        return otpRepository.validate()
//    }
}
