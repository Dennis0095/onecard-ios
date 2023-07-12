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
    func showMessageError(title: String, description: String, completion: VoidActionHandler?)
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
    
    func showMessageError(title: String, description: String, completion: VoidActionHandler?) {
        let view = AlertErrorViewController()
        view.titleError = title
        view.descriptionError = description
        view.accept = completion
        view.modalPresentationStyle = .custom
        view.transitioningDelegate = (navigationController?.topViewController as? BaseViewController)
        navigationController?.present(view, animated: true, completion: nil)
    }
}

extension AppRouter: AuthenticationRouterDelegate {
    func timeExpiredRegister() {
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                if let membershipDataViewController = viewController as? MembershipDataViewController {
                    navigationController?.popToViewController(membershipDataViewController, animated: true)
                    break
                }
            }
        }
    }
    
    func navigateToConfirmPin(newPin: String, success: @escaping PinActionHandler) {
        let cardRepository = CardDataRepository()
        let keyRepository = KeyDataRepository()
        let cardUseCase = CardUseCase(cardRepository: cardRepository)
        let keyUseCase = KeyUseCase(keyRepository: keyRepository)
        let viewModel = PinViewModel(router: self, cardUseCase: cardUseCase, keyUseCase: keyUseCase, pinStep: .cardActivation)
        viewModel.success = success
        viewModel.newPin = newPin
        let viewController = PinViewController(viewModel: viewModel, navTitle: "ACTIVACIÓN DE TARJETA", step: "Paso 3 de 3", titleDescription: "Confirme su nuevo PIN", buttonTitle: Constants.next_btn, placeholder: "Nuevo PIN", isConfirmPin: true)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToNewPin(success: @escaping PinActionHandler) {
        let cardRepository = CardDataRepository()
        let keyRepository = KeyDataRepository()
        let cardUseCase = CardUseCase(cardRepository: cardRepository)
        let keyUseCase = KeyUseCase(keyRepository: keyRepository)
        let viewModel = PinViewModel(router: self, cardUseCase: cardUseCase, keyUseCase: keyUseCase, pinStep: .reassign)
        viewModel.success = success
        let viewController = PinViewController(viewModel: viewModel, navTitle: "ACTIVACIÓN DE TARJETA", step: "Paso 2 de 3", titleDescription: "Ingrese su nuevo PIN", buttonTitle: Constants.next_btn, placeholder: "Nuevo PIN")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToPin(success: @escaping PinActionHandler) {
        let cardRepository = CardDataRepository()
        let keyRepository = KeyDataRepository()
        let cardUseCase = CardUseCase(cardRepository: cardRepository)
        let keyUseCase = KeyUseCase(keyRepository: keyRepository)
        let viewModel = PinViewModel(router: self, cardUseCase: cardUseCase, keyUseCase: keyUseCase, pinStep: .validate)
        viewModel.success = success
        let viewController = PinViewController(viewModel: viewModel, navTitle: "ACTIVACIÓN DE TARJETA", step: "Paso 1 de 3", titleDescription: "Ingrese el PIN de la tarjeta", description: "Puede encontrarlo dentro del sobre de la tarjeta.", buttonTitle: Constants.next_btn, placeholder: "PIN de la tarjeta")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToActivateUser() {
        let viewModel = WelcomeActivateViewModel(router: self, successfulRouter: self)
        let welcomeActivateViewController = WelcomeActivateViewController(viewModel: viewModel)
        navigationController?.pushViewController(welcomeActivateViewController, animated: true)
    }
    
    func navigateToLoginInformation(otpId: String, documentType: String, documentNumber: String, companyRUC: String) {
        let repository = UserDataRepository()
        let useCase = UserUseCase(userRepository: repository)
        let viewModel = LoginInformationViewModel(router: self, successfulRouter: self, userUseCase: useCase, otpId: otpId, documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC)
        let loginInformationViewController = LoginInformationViewController(viewModel: viewModel)
        navigationController?.pushViewController(loginInformationViewController, animated: true)
    }
    
    func navigateToPersonalData(beforeRequest: ValidateAffiliationRequest) {
        let repository = UserDataRepository()
        let useCase = UserUseCase(userRepository: repository)
        let viewModel = PersonalDataViewModel(router: self, verificationRouter: self, userUseCase: useCase, documentType: beforeRequest.documentType, documentNumber: beforeRequest.documentNumber, companyRUC: beforeRequest.companyRUC)
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
    func navigateToVerification(email: String, number: String, navTitle: String, stepDescription: String , success: @escaping VerificationActionHandler) {
        let repository = OTPDataRepository()
        let useCase = OTPUseCase(otpRepository: repository)
        let viewModel = VerificationViewModel(router: self, otpUseCase: useCase)
        viewModel.success = success
        let verificationViewController = VerificationViewController(viewModel: viewModel, navTitle: navTitle, step: stepDescription, titleDescription: "Ingrese su código de validación", number: number, email: email, buttonTitle: Constants.next_btn)
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
    
    func navigateToCardBlock(email: String, number: String, navTitle: String, success: @escaping VerificationActionHandler) {
        let repository = OTPDataRepository()
        let useCase = OTPUseCase(otpRepository: repository)
        let viewModel = VerificationViewModel(router: self, otpUseCase: useCase)
        viewModel.success = success
        let verificationViewController = VerificationViewController(viewModel: viewModel, navTitle: navTitle, number: number, email: email, buttonTitle: "BLOQUEAR", maskPhoneEmail: true)
        navigationController?.pushViewController(verificationViewController, animated: true)
    }
    
    func navigateToConfigureCard() {
        let viewModel = ConfigureCardViewModel(router: self, successfulRouter: self)
        let viewController = ConfigureCardViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
