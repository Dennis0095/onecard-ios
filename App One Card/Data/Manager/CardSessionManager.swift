//
//  CardSessionManager.swift
//  App One Card
//
//  Created by Paolo Arambulo on 25/07/23.
//

import Combine
import Foundation

protocol CardSessionManagerProtocol {
    func saveStatus(status: StatusCard?)
    func getStatus() -> StatusCard?
}

class CardSessionManager: CardSessionManagerProtocol {
    
    static let shared = CardSessionManager()
    
    private init() {}
    
    func saveStatus(status: StatusCard?) {
        CardObserver.shared.updateStatus(status: status)
        UserDefaults.standard.set(status?.rawValue, forKey: Constants.keyCardStatus)
        UserDefaults.standard.synchronize()
    }
    
    func getStatus() -> StatusCard? {
        if let status = UserDefaults.standard.string(forKey: Constants.keyCardStatus) {
            return StatusCard(rawValue: status)
        } else {
            return nil
        }
    }
}
