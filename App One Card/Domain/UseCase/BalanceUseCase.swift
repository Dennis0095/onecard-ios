//
//  BalanceUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 1/07/23.
//

import Combine

protocol BalanceUseCaseProtocol {
    func inquiry(request: BalanceInquiryRequest, completion: @escaping (Result<BalanceInquiryEntity, CustomError>) -> Void)
}

class BalanceUseCase: BalanceUseCaseProtocol {
    private let balanceRepository: BalanceRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(balanceRepository: BalanceRepository) {
        self.balanceRepository = balanceRepository
    }
    
    deinit {
        cancelRequests()
    }
    
    func inquiry(request: BalanceInquiryRequest, completion: @escaping (Result<BalanceInquiryEntity, CustomError>) -> Void) {
        let cancellable = balanceRepository.inquiry(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    let error = CustomError(title: "Error", description: error.localizedDescription)
                    completion(.failure(error))
                }
            } receiveValue: { response in
                let description = response.description ?? ""
                
                if response.rc == "0" {
                    completion(.success(response))
                } else {
                    let error = CustomError(title: "", description: description, actionAfterFailure: true)
                    completion(.failure(error))
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
