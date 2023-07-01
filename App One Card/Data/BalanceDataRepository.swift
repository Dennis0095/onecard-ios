//
//  BalanceDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 1/07/23.
//

import Foundation
import Combine

class BalanceDataRepository: BalanceRepository {
    func inquiry(request: BalanceInquiryRequest) -> AnyPublisher<BalanceInquiryEntity, Error> {
        return APIClient.callAPI(route: .balanceInquiry, method: .post, request: request, showLoading: true)
    }
}
