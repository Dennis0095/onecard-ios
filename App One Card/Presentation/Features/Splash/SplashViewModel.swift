//
//  SplashViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import Foundation

protocol SplashViewModelProtocol {
    var isLoggedIn: Bool { get }
    
    func validateLoginStatus()
}

class SplashViewModel: SplashViewModelProtocol {
    var router: AuthenticationRouterDelegate
    
    init(router: AuthenticationRouterDelegate) {
        self.router = router
    }
    
    var isLoggedIn: Bool = false
    
    func validateLoginStatus() {
        isLoggedIn = false
        
        if isLoggedIn {
            
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.router.navigateToLogin()
            }
        }
    }
}
