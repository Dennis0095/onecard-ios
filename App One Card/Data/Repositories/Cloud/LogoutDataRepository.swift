//
//  LogoutDataRepository.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 9/05/24.
//

import Foundation
import Combine

class LogoutDataRepository: LogoutRepository {
    func logout(request: BaseRequest) -> AnyPublisher<LogoutResponse, APIError> {
        return APIClient.callAPI(route: .logout, method: .post, request: request)
    }
}
