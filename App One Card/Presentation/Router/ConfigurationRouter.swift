//
//  ConfigurationRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/06/23.
//

import Foundation

protocol ConfigurationRouterDelegate: Router {
    func navigateToProfile()
    func navigateToQuestions()
    func confirmLogout(accept: VoidActionHandler?)
}
