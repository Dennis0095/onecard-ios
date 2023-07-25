//
//  CardLocalUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import Foundation

protocol CardLocalUseCaseProtocol {
    func saveStatus(status: String?)
    func getStatus() -> String?
}

class CardLocalUseCase: CardLocalUseCaseProtocol {
    private let cardLocalRepository: CardLocalRepository
    
    init(cardLocalRepository: CardLocalRepository) {
        self.cardLocalRepository = cardLocalRepository
    }
    
    func saveStatus(status: String?) {
        cardLocalRepository.saveStatus(status: status)
    }
    
    func getStatus() -> String? {
        return cardLocalRepository.getStatus()
    }
}
