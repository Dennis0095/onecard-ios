//
//  WelcomeActivateViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 20/06/23.
//

import Foundation

protocol WelcomeActivateViewModelProtocol {

    func toPin()
    func toChangePin()
    func toConfirmPin()
    func toHome()
}

class WelcomeActivateViewModel: WelcomeActivateViewModelProtocol {
    var router: AuthenticationRouterDelegate
    
    init(router: AuthenticationRouterDelegate) {
        self.router = router
    }
    
    func toPin() {
        
    }
    
    func toChangePin() {
        
    }
    
    func toConfirmPin() {
        
    }
    
    func toHome() {
        router.navigateToHome()
    }
}
