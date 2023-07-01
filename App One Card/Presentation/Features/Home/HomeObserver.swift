//
//  HomeObserver.swift
//  App One Card
//
//  Created by Paolo Arambulo on 1/07/23.
//

import Foundation
import Combine

protocol HomeObserverProtocol {
    var amountPublisher: Published<String?>.Publisher { get }
    var listenAmountChanges: ((_ amount: String) -> Void)? { get }
    
    func updateAmount(amount: String?)
    func bindPublishers()
}

class HomeObserver: HomeObserverProtocol {
        
    static let shared = HomeObserver()
    
    var amountPublisher: Published<String?>.Publisher { $amount }
    var listenAmountChanges: ((_ amount: String) -> Void)?
    
    @Published private var amount: String?
    private var cancellables: Set<AnyCancellable> = []
    
    private init() {
        bindPublishers()
    }
    
    func updateAmount(amount: String?) {
        self.amount = amount
    }
    
    func bindPublishers() {
        amountPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] amount in
                if let amount = amount {
                    if let action = self?.listenAmountChanges {
                        action(amount)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
