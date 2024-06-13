//
//  LogoutRepository.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 9/05/24.
//

import Foundation
import Combine

protocol LogoutRepository {
    func logout(request: BaseRequest) -> AnyPublisher<LogoutResponse, APIError>
}
