//
//  PreferencesViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/06/23.
//

import Foundation

protocol PreferencesViewModelProtocol {
    func toProfile()
    func toQuestions()
    func toContact()
    func logout()
}

class PreferencesViewModel: PreferencesViewModelProtocol {
    var router: PreferencesRouterDelegate?
    
    func toProfile() {
        router?.navigateToProfile()
    }
    
    func toQuestions() {
        router?.navigateToQuestions()
    }
    
    func toContact() {
        router?.navigateToContact()
    }
    
    func logout() {
        router?.logout()
    }
}
