//
//  CardLocalDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import Combine
import Foundation

class CardLocalDataRepository: CardLocalRepository {
    func saveStatus(status: String?) {
        CardObserver.shared.updateStatus(status: status)
        UserDefaults.standard.set(status, forKey: Constants.keyCardStatus)
        UserDefaults.standard.synchronize()
    }
    
    func getStatus() -> String? {
        if let token = UserDefaults.standard.string(forKey: Constants.keyCardStatus) {
            return token
        } else {
            return nil
        }
    }
}
