//
//  VerificationViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 7/06/23.
//

import Foundation
import Combine

protocol VerificationViewModelProtocol {
    func successVerification()
}

class VerificationViewModel: VerificationViewModelProtocol {
    private var cancellables = Set<AnyCancellable>()
    var success: VoidActionHandler?
    
    func successVerification() {
        if let action = success {
            action()
        }
    }
}
