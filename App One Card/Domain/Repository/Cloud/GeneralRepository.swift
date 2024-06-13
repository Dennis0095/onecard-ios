//
//  GeneralRepository.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 9/05/24.
//

import Foundation
import Combine

protocol GeneralRepository {
    func getParameters() -> AnyPublisher<GeneralParametersResponse, APIError>
}
