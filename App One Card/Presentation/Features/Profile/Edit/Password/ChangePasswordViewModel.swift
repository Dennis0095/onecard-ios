//
//  ChangePasswordViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 20/07/23.
//

import Foundation

protocol ChangePasswordViewModelProtocol {
    var password: String? { get set }
    var newPassword: String? { get set }
    var passwordOk: String? { get set }
    var delegate: ChangePasswordViewModelDelegate? { get set }
}

protocol ChangePasswordViewModelDelegate: LoaderDisplaying {}

class ChangePasswordViewModel: ChangePasswordViewModelProtocol {
    var password: String?
    var newPassword: String?
    var passwordOk: String?
    var delegate: ChangePasswordViewModelDelegate?
    var profileRouter: ProfileRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    
    init(profileRouter: ProfileRouterDelegate, successfulRouter: SuccessfulRouterDelegate) {
        self.profileRouter = profileRouter
        self.successfulRouter = successfulRouter
    }
}
