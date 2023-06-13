//
//  ProfileRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/06/23.
//

import Foundation

protocol ProfileRouterDelegate: Router {
    func toEditMail()
    func toEditUser()
    func toEditPassword()
    func successfulEditProfile()
}
