//
//  SuccessfulRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/06/23.
//

import UIKit

protocol SuccessfulRouterDelegate: Router {
    func navigateToSuccessfulScreen(title: String, description: String, button: String, image: UIImage, accept: VoidActionHandler?)
}
