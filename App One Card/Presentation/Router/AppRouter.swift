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
    func showMessageError(title: String, description: String)
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
    
    func showMessageError(title: String, description: String) {
        let view = AlertErrorViewController()
        view.titleError = title
        view.descriptionError = description
        view.modalPresentationStyle = .custom
        view.transitioningDelegate = (navigationController?.topViewController as? BaseViewController)
        navigationController?.present(view, animated: true, completion: nil)
    }
}

extension AppRouter: AuthenticationRouterDelegate {
    func navigateToPin() {
        let viewController = PinViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToActivateUser() {
        let viewModel = WelcomeActivateViewModel(router: self)
        let welcomeActivateViewController = WelcomeActivateViewController(viewModel: viewModel)
        navigationController?.pushViewController(welcomeActivateViewController, animated: true)
    }
    
    func navigateToLoginInformation() {
        let viewModel = LoginInformationViewModel(router: self, successfulRouter: self)
        let loginInformationViewController = LoginInformationViewController(viewModel: viewModel)
        navigationController?.pushViewController(loginInformationViewController, animated: true)
    }
    
    func navigateToPersonalData(beforeRequest: ValidateAffiliationRequest) {
        let viewModel = PersonalDataViewModel(router: self, verificationRouter: self, beforeRequest: beforeRequest)
        let personalDataViewController = PersonalDataViewController(viewModel: viewModel)
        navigationController?.pushViewController(personalDataViewController, animated: true)
    }
    
    func navigateToRegister() {
        let repository = UserDataRepository()
        let useCase = UserUseCase(userRepository: repository)
        let viewModel = MembershipDataViewModel(router: self, userUseCase: useCase)
        let membershipDataViewController = MembershipDataViewController(viewModel: viewModel)
        //interactor.membershipDataView = membershipDataViewController
        navigationController?.pushViewController(membershipDataViewController, animated: true)
    }
    
    func navigateToHome() {
        let menu = MenuTabBarController(homeRouter: self, preferencesRouter: self, successfulRouter: self)
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
        let verificationViewController = VerificationViewController(viewModel: viewModel, navTitle: navTitle, step: stepDescription, titleDescription: "Ingrese sus datos personales", number: "999222333", buttonTitle: Constants.next_btn)
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
        let viewController = FrequentQuestionsViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToContact() {
        
    }
    
    func logout() {
        navigationController = nil
        
        let viewModel = LoginViewModel(router: self)
        let loginViewController = LoginViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController?.setNavigationBarHidden(true, animated: true)
        if let nav = navigationController {
            window.switchRootViewController(to: nav)
        }
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

extension AppRouter: HomeRouterDelegate {
    func successfulConfigureCard() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func successfulCardBlock() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func navigateToCardBlock(navTitle: String, success: @escaping VoidActionHandler) {
        let viewModel = VerificationViewModel()
        viewModel.success = success
        let verificationViewController = VerificationViewController(viewModel: viewModel, navTitle: navTitle, number: "******333", buttonTitle: "BLOQUEAR")
        navigationController?.pushViewController(verificationViewController, animated: true)
    }
    
    func navigateToConfigureCard() {
        let viewModel = ConfigureCardViewModel(router: self, successfulRouter: self)
        let viewController = ConfigureCardViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
