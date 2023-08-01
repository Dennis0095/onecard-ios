//
//  BalanceUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 1/07/23.
//

import Combine

protocol BalanceUseCaseProtocol {
    func inquiry(request: BalanceInquiryRequest) -> AnyPublisher<BalanceInquiryResponse, Error>
}

class BalanceUseCase: BalanceUseCaseProtocol {
    private let balanceRepository: BalanceRepository
    
    init(balanceRepository: BalanceRepository) {
        self.balanceRepository = balanceRepository
    }
    
    func inquiry(request: BalanceInquiryRequest) -> AnyPublisher<BalanceInquiryResponse, Error> {
        return balanceRepository.inquiry(request: request)
    }
}
