//
//  BalanceRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 1/07/23.
//

import Combine

protocol BalanceRepository {
    func inquiry(request: BalanceInquiryRequest) -> AnyPublisher<BalanceInquiryResponse, Error>
}
