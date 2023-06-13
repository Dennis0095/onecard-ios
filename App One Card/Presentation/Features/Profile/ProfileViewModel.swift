//
//  ProfileViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/06/23.
//

import Foundation

protocol ProfileViewModelProtocol {
    func toEditMail()
    func toEditUser()
    func toEditPassword()
}

class ProfileViewModel: ProfileViewModelProtocol {
    var router: ProfileRouterDelegate
    
    init(router: ProfileRouterDelegate) {
        self.router = router
    }
    
    func toEditMail() {
        router.toEditMail()
    }
    
    func toEditUser() {
        router.toEditUser()
    }
    
    func toEditPassword() {
        router.toEditPassword()
    }
}
