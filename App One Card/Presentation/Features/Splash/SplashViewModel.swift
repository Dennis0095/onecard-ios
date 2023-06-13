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
            router.navigateToLogin()
        }
    }
    
    func didSelectItem(withID id: String) {
        // Handle the selection logic
        // Call the router to navigate to the details view with the selected ID
        //router.navigateToDetails(withID: id)
    }
}
