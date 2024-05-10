//
//  GeneralDataRepository.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 9/05/24.
//

import Foundation
import Combine

class GeneralDataRepository: GeneralRepository {
    func getParameters() -> AnyPublisher<GeneralParametersResponse, APIError> {
        return APIClient.callAPI(route: .consultGeneralParameters, method: .post)
    }
}
