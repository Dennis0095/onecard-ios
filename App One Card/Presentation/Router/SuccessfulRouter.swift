//
//  SuccessfulRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/06/23.
//

import Foundation

protocol SuccessfulRouterDelegate: Router {
    func navigateToSuccessfulScreen(title: String, description: String, button: String, accept: VoidActionHandler?)
}
