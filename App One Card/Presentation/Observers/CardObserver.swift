//
//  CardObserver.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import Foundation
import Combine

protocol CardObserverProtocol {
    var statusPublisher: Published<StatusCard?>.Publisher { get }
    var listenStatusChanges: ((_ status: StatusCard) -> Void)? { get }
    
    func updateStatus(status: StatusCard?)
    func bindPublishers()
}

class CardObserver: CardObserverProtocol {
        
    static let shared = CardObserver()
    
    @Published private var status: StatusCard?
    
    var statusPublisher: Published<StatusCard?>.Publisher { $status }
    var listenStatusChanges: ((_ status: StatusCard) -> Void)?
    
    private var cancellables: Set<AnyCancellable> = []
    
    private init() {
        bindPublishers()
    }
    
    func updateStatus(status: StatusCard?) {
        self.status = status
    }
    
    func getStatus() -> StatusCard? {
        return self.status
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

enum StatusCard: String {
    case ACTIVE = "A" //ACTIVE
    case NOT_ACTIVE = "P" //NOT ACTIVE
    case TEMPORARY_LOCKED = "X" //TEMPORARY LOCKED
    case CANCEL = "C" //CANCEL
}
