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
    func successfulRegistration(title: String, description: String, accept: VoidActionHandler?) {
        let successfulViewController = SuccessfulViewController()
        successfulViewController.titleSuccessful = title
        successfulViewController.descriptionSuccessful = description
        successfulViewController.buttonSuccessful = Constants.enter
        successfulViewController.accept = accept
        navigationController?.pushViewController(successfulViewController, animated: true)
    }
    
    func navigateToLoginInformation() {
        let viewModel = LoginInformationViewModel()
        viewModel.router = self
        let loginInformationViewController = LoginInformationViewController(viewModel: viewModel)
        navigationController?.pushViewController(loginInformationViewController, animated: true)
    }
    
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
        let viewModel = MembershipDataViewModel()
        viewModel.router = self
        let membershipDataViewController = MembershipDataViewController(viewModel: viewModel)
        navigationController?.pushViewController(membershipDataViewController, animated: true)
    }
    
    func navigateToHome() {
        
    }
    
    func navigateToLogin() {
        let viewModel = LoginViewModel()
        viewModel.router = self
        let loginViewController = LoginViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController?.setNavigationBarHidden(true, animated: true)
        if let nav = navigationController {
            window.switchRootViewController(to: nav)
        }
    }
    
    func showDateList(selected: Date?, action: @escaping SelectDateActionHandler, presented: @escaping VoidActionHandler) {
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
    
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping VoidActionHandler) {
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
