//
//  HomeRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/06/23.
//

import Foundation

protocol HomeRouterDelegate: Router {
    func navigateToCardBlock(navTitle: String, success: @escaping VoidActionHandler)
    func successfulCardBlock()
}
