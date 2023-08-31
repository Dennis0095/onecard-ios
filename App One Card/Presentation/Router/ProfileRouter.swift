//
//  ProfileRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/06/23.
//

import Foundation

protocol ProfileRouterDelegate: Router {
    func toEditMail(beforeEmail: String, otpId: String, success: @escaping EditMailSuccessActionHandler)
    func toEditUser(beforeUsername: String, otpId: String, success: @escaping EditUserSuccessActionHandler)
    func toEditPassword()
    func successfulEditProfile()
}
