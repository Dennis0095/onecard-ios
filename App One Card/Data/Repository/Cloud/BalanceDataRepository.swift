//
//  BalanceDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 1/07/23.
//

import Combine

class BalanceDataRepository: BalanceRepository {
    func inquiry(request: BalanceInquiryRequest) -> AnyPublisher<BalanceInquiryResponse, APIError> {
        return APIClient.callAPI(route: .balanceInquiry, method: .post, request: request)
    }
}
