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
    
    var movementsPublisher: Published<[MovementEntity]?>.Publisher { get }
    var listenMovementsChanges: ((_ movements: [MovementEntity]) -> Void)? { get }
    
    func updateAmount(amount: String?)
    func updateMovements(movements: [MovementEntity]?)
    func bindPublishers()
}

class HomeObserver: HomeObserverProtocol {
        
    static let shared = HomeObserver()
    
    var amountPublisher: Published<String?>.Publisher { $amount }
    var listenAmountChanges: ((_ amount: String) -> Void)?
    
    var movementsPublisher: Published<[MovementEntity]?>.Publisher { $movements }
    var listenMovementsChanges: ((_ movements: [MovementEntity]) -> Void)?
    
    @Published private var amount: String?
    @Published private var movements: [MovementEntity]?
    private var cancellables: Set<AnyCancellable> = []
    
    private init() {
        bindPublishers()
    }
    
    func updateAmount(amount: String?) {
        self.amount = amount
    }
    
    func updateMovements(movements: [MovementEntity]?) {
        self.movements = movements
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
        
        movementsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movements in
                if let movements = movements {
                    if let action = self?.listenMovementsChanges {
                        action(movements)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
