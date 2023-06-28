//
//  OTPDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 27/06/23.
//

import Combine

class OTPDataRepository: OTPRepository {
    func send(request: SendOTPRequest) -> AnyPublisher<SendOTPEntity, Error> {
        return APIClient.callAPI(route: .validateAffiliation, method: .post, request: request, showLoading: true)
    }
    
//    func validate() -> AnyPublisher<ExampleEntity, Error> {
//
//    }
}
