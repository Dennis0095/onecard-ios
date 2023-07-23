//
//  PreferencesViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/06/23.
//

import UIKit

protocol PreferencesViewModelProtocol {
    func toProfile()
    func toQuestions()
    func toContact(phoneNumber: String)
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
    
    func toContact(phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func logout() {
        router?.logout()
    }
}
