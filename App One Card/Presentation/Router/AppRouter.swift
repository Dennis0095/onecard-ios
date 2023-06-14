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
        let splashViewModel = SplashViewModel(router: self)
        let splashViewController = SplashViewController(splashViewModel: splashViewModel)
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }
}

extension AppRouter: AuthenticationRouterDelegate {
    func navigateToLoginInformation() {
        let viewModel = LoginInformationViewModel(router: self, successfulRouter: self)
        let loginInformationViewController = LoginInformationViewController(viewModel: viewModel)
        navigationController?.pushViewController(loginInformationViewController, animated: true)
    }
    
    func navigateToPersonalData() {
        let viewModel = PersonalDataViewModel(router: self, verificationRouter: self)
        let personalDataViewController = PersonalDataViewController(viewModel: viewModel)
        navigationController?.pushViewController(personalDataViewController, animated: true)
    }
    
    func navigateToRegister() {
        let viewModel = MembershipDataViewModel(router: self)
        let membershipDataViewController = MembershipDataViewController(viewModel: viewModel)
        navigationController?.pushViewController(membershipDataViewController, animated: true)
    }
    
    func navigateToHome() {
        let menu = MenuTabBarController(preferencesRouter: self)
        navigationController = UINavigationController(rootViewController: menu)
        navigationController?.setNavigationBarHidden(true, animated: true)
        if let nav = navigationController {
            window.switchRootViewController(to: nav)
        }
    }
    
    func navigateToLogin() {
        let viewModel = LoginViewModel(router: self)
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

extension AppRouter: VerificationRouterDelegate {    
    func navigateToVerification(navTitle: String, stepDescription: String , success: @escaping VoidActionHandler) {
        let viewModel = VerificationViewModel()
        viewModel.success = success
        let verificationViewController = VerificationViewController(viewModel: viewModel, navTitle: navTitle, step: stepDescription, number: "999222333")
        navigationController?.pushViewController(verificationViewController, animated: true)
    }
}

extension AppRouter: SuccessfulRouterDelegate {
    func navigateToSuccessfulScreen(title: String, description: String, button: String, accept: VoidActionHandler?) {
        let successfulViewController = SuccessfulViewController()
        successfulViewController.titleSuccessful = title
        successfulViewController.descriptionSuccessful = description
        successfulViewController.buttonSuccessful = button
        successfulViewController.accept = accept
        navigationController?.pushViewController(successfulViewController, animated: true)
    }
}

extension AppRouter: PreferencesRouterDelegate {
    func navigateToProfile() {
        let viewModel = ProfileViewModel(router: self)
        let profileViewController = ProfileViewController(viewModel: viewModel)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func navigateToQuestions() {
        
    }
    
    func navigateToContact() {
        
    }
    
    func logout() {
        
    }
}

extension AppRouter: ProfileRouterDelegate {
    func toEditPassword() {
        
    }
    
    func toEditUser() {
        let viewModel = EditUserViewModel(profileRouter: self, successfulRouter: self, verificationRouter: self)
        let editUserViewController = EditUserViewController(viewModel: viewModel)
        navigationController?.pushViewController(editUserViewController, animated: true)
    }
    
    func toEditMail() {
        let viewModel = EditMailViewModel(profileRouter: self, successfulRouter: self, verificationRouter: self)
        let editMailViewController = EditMailViewController(viewModel: viewModel)
        navigationController?.pushViewController(editMailViewController, animated: true)
    }
    
    func successfulEditProfile() {
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                if let profileViewController = viewController as? ProfileViewController {
                    navigationController?.popToViewController(profileViewController, animated: true)
                    break
                }
            }
        }
    }
}
