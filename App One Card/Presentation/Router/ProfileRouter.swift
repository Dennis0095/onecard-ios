//
//  ProfileRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/06/23.
//

import Foundation

protocol ProfileRouterDelegate: Router {
    func toEditMail(beforeEmail: String, otpId: String)
    func toEditUser(beforeUsername: String, otpId: String)
    func toEditPassword()
    func successfulEditProfile()
}
