//
//  BannersDataRepository.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 6/03/24.
//

import Combine

class BannersDataRepository: BannersRepository {
    func consult(request: ConsultBannersRequest) -> AnyPublisher<ConsultBannersResponse, APIError> {
        return APIClient.callAPI(route: .banners, method: .post, request: request)
    }
}
