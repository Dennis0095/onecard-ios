//
//  AppRouter.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import Foundation
import UIKit

protocol Router {
    func start()
}

class AppRouter: Router {
    private let window: UIWindow
    var navigationController: UINavigationController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let splashViewModel = SplashViewModel()
        splashViewModel.router = self
        let splashViewController = SplashViewController(splashViewModel: splashViewModel)
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }
}

extension AppRouter: AuthenticationRouterDelegate {
    func navigateToVerify() {
        let viewModel = VerificationViewModel()
        viewModel.router = self
        let verificationViewController = VerificationViewController(viewModel: viewModel)
        navigationController?.pushViewController(verificationViewController, animated: true)
    }
    
    func navigateToPersonalData() {
        let viewModel = PersonalDataViewModel()
        viewModel.router = self
        let personalDataViewController = PersonalDataViewController(viewModel: viewModel)
        navigationController?.pushViewController(personalDataViewController, animated: true)
    }
    
    func navigateToRegister() {
        let membershipDataViewModel = MembershipDataViewModel()
        membershipDataViewModel.router = self
        let membershipDataViewController = MembershipDataViewController(membershipDataViewModel: membershipDataViewModel)
        navigationController?.pushViewController(membershipDataViewController, animated: true)
    }
    
    func navigateToHome() {
        
    }
    
    func navigateToLogin() {
        let loginViewModel = LoginViewModel()
        loginViewModel.router = self
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController?.setNavigationBarHidden(true, animated: true)
        if let nav = navigationController {
            window.switchRootViewController(to: nav)
        }
    }
    
    func showDateList(selected: Date?, action: @escaping SelectDateActionHandler, presented: @escaping DismissActionHandler) {
        let contentView = SelectDateViewController()
        contentView.textTitle = Constants.placeholder_birthday
        contentView.selectedItem = selected
        contentView.actionHandler = action
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.setValue(contentView, forKey: "contentViewController")
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alertController.view.tintColor = UIColor.white
        navigationController?.present(alertController, animated: true, completion: presented)
    }
    
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping DismissActionHandler) {
        let contentView = SelectCustomViewController()
        contentView.textTitle = Constants.placeholder_document_type
        contentView.items = list
        contentView.selectedItem = selected
        contentView.actionHandler = action
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.setValue(contentView, forKey: "contentViewController")
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alertController.view.tintColor = UIColor.white
        navigationController?.present(alertController, animated: true, completion: presented)
    }
}
