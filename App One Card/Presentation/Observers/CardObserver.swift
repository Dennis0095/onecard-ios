//
//  CardObserver.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import Foundation
import Combine

protocol CardObserverProtocol {
    var statusPublisher: Published<String?>.Publisher { get }
    var listenStatusChanges: ((_ status: String) -> Void)? { get }
    
    func updateStatus(status: String?)
    func bindPublishers()
}

class CardObserver: CardObserverProtocol {
        
    static let shared = CardObserver()
    
    @Published private var status: String?
    
    var statusPublisher: Published<String?>.Publisher { $status }
    var listenStatusChanges: ((_ status: String) -> Void)?
    
    private var cancellables: Set<AnyCancellable> = []
    
    private init() {
        bindPublishers()
    }
    
    func updateStatus(status: String?) {
        self.status = status
    }
    
    func bindPublishers() {
        statusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if let status = status {
                    if let action = self?.listenStatusChanges {
                        action(status)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
