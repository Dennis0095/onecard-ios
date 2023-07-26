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
    func backToHome()
    //func showMessageError(title: String, description: String, completion: VoidActionHandler?)
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
    
    func backToHome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
//    func showMessageError(title: String, description: String, completion: VoidActionHandler?) {
//        let view = AlertErrorViewController()
//        view.titleError = title
//        view.descriptionError = description
//        view.accept = completion
//        view.modalPresentationStyle = .custom
//        view.transitioningDelegate = (navigationController?.topViewController as? BaseViewController)
//        navigationController?.present(view, animated: true, completion: nil)
//    }
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
        DispatchQueue.main.async {
            let cardRepository = CardDataRepository()
            let keyRepository = KeyDataRepository()
            let cardUseCase = CardUseCase(cardRepository: cardRepository)
            let keyUseCase = KeyUseCase(keyRepository: keyRepository)
            let viewModel = PinViewModel(router: self, cardUseCase: cardUseCase, keyUseCase: keyUseCase, pinStep: .cardActivation)
            viewModel.success = success
            viewModel.newPin = newPin
            let viewController = PinViewController(viewModel: viewModel, navTitle: "ACTIVACIÓN DE TARJETA", step: "Paso 3 de 3", titleDescription: "Confirme su nuevo PIN", buttonTitle: Constants.next_btn, placeholder: "Nuevo PIN", isConfirmPin: true)
            viewModel.delegate = viewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func navigateToNewPin(success: @escaping PinActionHandler) {
        DispatchQueue.main.async {
            let cardRepository = CardDataRepository()
            let keyRepository = KeyDataRepository()
            let cardUseCase = CardUseCase(cardRepository: cardRepository)
            let keyUseCase = KeyUseCase(keyRepository: keyRepository)
            let viewModel = PinViewModel(router: self, cardUseCase: cardUseCase, keyUseCase: keyUseCase, pinStep: .nothing)
            viewModel.success = success
            let viewController = PinViewController(viewModel: viewModel, navTitle: "ACTIVACIÓN DE TARJETA", step: "Paso 2 de 3", titleDescription: "Ingrese su nuevo PIN", buttonTitle: Constants.next_btn, placeholder: "Nuevo PIN")
            viewModel.delegate = viewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    func navigateToPin(success: @escaping PinActionHandler) {
        DispatchQueue.main.async {
            let cardRepository = CardDataRepository()
            let keyRepository = KeyDataRepository()
            let cardUseCase = CardUseCase(cardRepository: cardRepository)
            let keyUseCase = KeyUseCase(keyRepository: keyRepository)
            let viewModel = PinViewModel(router: self, cardUseCase: cardUseCase, keyUseCase: keyUseCase, pinStep: .validate)
            viewModel.success = success
            let viewController = PinViewController(viewModel: viewModel, navTitle: "ACTIVACIÓN DE TARJETA", step: "Paso 1 de 3", titleDescription: "Ingrese el PIN de la tarjeta", description: "Puede encontrarlo dentro del sobre de la tarjeta.", buttonTitle: Constants.next_btn, placeholder: "PIN de la tarjeta")
            viewModel.delegate = viewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func navigateToActivateUser() {
        DispatchQueue.main.async {
            let viewModel = WelcomeActivateViewModel(router: self, successfulRouter: self)
            let welcomeActivateViewController = WelcomeActivateViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(welcomeActivateViewController, animated: true)
        }
    }
    
    func navigateToLoginInformation(otpId: String, documentType: String, documentNumber: String, companyRUC: String) {
        let repository = UserDataRepository()
        let useCase = UserUseCase(userRepository: repository)
        let viewModel = LoginInformationViewModel(router: self, successfulRouter: self, userUseCase: useCase, otpId: otpId, documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC)
        let loginInformationViewController = LoginInformationViewController(viewModel: viewModel)
        viewModel.delegate = loginInformationViewController
        navigationController?.pushViewController(loginInformationViewController, animated: true)
    }
    
    func navigateToPersonalData(beforeRequest: ValidateAffiliationRequest) {
        let repository = UserDataRepository()
        let useCase = UserUseCase(userRepository: repository)
        let viewModel = PersonalDataViewModel(router: self, verificationRouter: self, userUseCase: useCase, documentType: beforeRequest.documentType, documentNumber: beforeRequest.documentNumber, companyRUC: beforeRequest.companyRUC)
        let personalDataViewController = PersonalDataViewController(viewModel: viewModel)
        viewModel.delegate = personalDataViewController
        navigationController?.pushViewController(personalDataViewController, animated: true)
    }
    
    func navigateToRegister() {
        let repository = UserDataRepository()
        let useCase = UserUseCase(userRepository: repository)
        let viewModel = MembershipDataViewModel(router: self, userUseCase: useCase)
        let membershipDataViewController = MembershipDataViewController(viewModel: viewModel)
        //interactor.membershipDataView = membershipDataViewController
        viewModel.delegate = membershipDataViewController
        navigationController?.pushViewController(membershipDataViewController, animated: true)
    }
    
    func navigateToHome() {
        let menu = MenuTabBarController(homeRouter: self, authRouter: self, preferencesRouter: self, successfulRouter: self, promotionsRouter: self)
        self.navigationController = UINavigationController(rootViewController: menu)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if let nav = self.navigationController {
            DispatchQueue.main.async {
                self.window.switchRootViewController(to: nav)
            }
        }
    }
    
    func navigateToLogin() {
        let userRepository = UserDataRepository()
        let userUseCase = UserUseCase(userRepository: userRepository)
        let cardRepository = CardDataRepository()
        let cardUseCase = CardUseCase(cardRepository: cardRepository)
        let viewModel = LoginViewModel(router: self, userUseCase: userUseCase, cardUseCase: cardUseCase)
        let loginViewController = LoginViewController(viewModel: viewModel)
        viewModel.delegate = loginViewController
        navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController?.setNavigationBarHidden(true, animated: true)
        if let nav = navigationController {
            DispatchQueue.main.async {
                self.window.switchRootViewController(to: nav)
            }
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
    func navigateToVerification(email: String, number: String, documentType: String, documentNumber: String, companyRUC: String, navTitle: String, stepDescription: String, success: @escaping VerificationActionHandler) {
        let repository = OTPDataRepository()
        let useCase = OTPUseCase(otpRepository: repository)
        let viewModel = VerificationViewModel(router: self, otpUseCase: useCase, documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC, number: number, email: email)
        viewModel.success = success
        let verificationViewController = VerificationViewController(viewModel: viewModel, navTitle: navTitle, step: stepDescription, titleDescription: "Ingrese su código de validación", buttonTitle: Constants.next_btn)
        viewModel.delegate = verificationViewController
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
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(successfulViewController, animated: true)
        }
    }
}

extension AppRouter: PreferencesRouterDelegate {
    func navigateToProfile() {
        let userRepository = UserDataRepository()
        let userUseCase = UserUseCase(userRepository: userRepository)
        let viewModel = ProfileViewModel(router: self, verificationRouter: self, userUseCase: userUseCase)
        let profileViewController = ProfileViewController(viewModel: viewModel)
        viewModel.delegate = profileViewController
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func navigateToQuestions() {
        let viewController = FrequentQuestionsViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func logout() {
        navigationController = nil
        
        let userRepository = UserDataRepository()
        let userUseCase = UserUseCase(userRepository: userRepository)
        let cardRepository = CardDataRepository()
        let cardUseCase = CardUseCase(cardRepository: cardRepository)
        let viewModel = LoginViewModel(router: self, userUseCase: userUseCase, cardUseCase: cardUseCase)
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
        let viewModel = ChangePasswordViewModel(profileRouter: self, successfulRouter: self)
        let changePasswordViewController = ChangePasswordViewController(viewModel: viewModel)
        navigationController?.pushViewController(changePasswordViewController, animated: true)
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
    func confirmCardLock(accept: VoidActionHandler?) {
        let view = CardLockModalViewController()
        view.accept = accept
        view.modalPresentationStyle = .overFullScreen
        view.modalTransitionStyle = .crossDissolve
        navigationController?.present(view, animated: true, completion: nil)
    }
    
    func navigateToInputPinConfirmation(newPin: String, success: @escaping PinActionHandler) {
        DispatchQueue.main.async {
            let cardRepository = CardDataRepository()
            let keyRepository = KeyDataRepository()
            let cardUseCase = CardUseCase(cardRepository: cardRepository)
            let keyUseCase = KeyUseCase(keyRepository: keyRepository)
            let viewModel = PinViewModel(router: self, cardUseCase: cardUseCase, keyUseCase: keyUseCase, pinStep: .reassign)
            viewModel.success = success
            viewModel.newPin = newPin
            let viewController = PinViewController(viewModel: viewModel, navTitle: "CAMBIO DE PIN", step: "Paso 3 de 3", titleDescription: "Confirme su nuevo PIN", buttonTitle: Constants.next_btn, placeholder: "Nuevo PIN", isConfirmPin: true)
            viewModel.delegate = viewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func navigateToInputNewPin(success: @escaping PinActionHandler) {
        DispatchQueue.main.async {
            let cardRepository = CardDataRepository()
            let keyRepository = KeyDataRepository()
            let cardUseCase = CardUseCase(cardRepository: cardRepository)
            let keyUseCase = KeyUseCase(keyRepository: keyRepository)
            let viewModel = PinViewModel(router: self, cardUseCase: cardUseCase, keyUseCase: keyUseCase, pinStep: .nothing)
            viewModel.success = success
            let viewController = PinViewController(viewModel: viewModel, navTitle: "CAMBIO DE PIN", step: "Paso 2 de 3", titleDescription: "Ingrese su nuevo PIN", buttonTitle: Constants.next_btn, placeholder: "Nuevo PIN")
            viewModel.delegate = viewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    func navigateToInputCurrentPin(success: @escaping PinActionHandler) {
        DispatchQueue.main.async {
            let cardRepository = CardDataRepository()
            let keyRepository = KeyDataRepository()
            let cardUseCase = CardUseCase(cardRepository: cardRepository)
            let keyUseCase = KeyUseCase(keyRepository: keyRepository)
            let viewModel = PinViewModel(router: self, cardUseCase: cardUseCase, keyUseCase: keyUseCase, pinStep: .validate)
            viewModel.success = success
            let viewController = PinViewController(viewModel: viewModel, navTitle: "CAMBIO DE PIN", step: "Paso 1 de 3", titleDescription: "Ingrese su PIN actual", buttonTitle: Constants.next_btn, placeholder: "PIN actual")
            viewModel.delegate = viewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func successfulConfigureCard() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func successfulCardBlock() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func navigateToCardBlock(email: String, number: String, navTitle: String, success: @escaping VerificationActionHandler) {
        let repository = OTPDataRepository()
        let useCase = OTPUseCase(otpRepository: repository)
        let cardRepository = CardDataRepository()
        let cardUseCase = CardUseCase(cardRepository: cardRepository)
        let viewModel = CardLockViewModel(router: self, otpUseCase: useCase, cardUseCase: cardUseCase, number: number, email: email)
        viewModel.success = success
        let cardLockViewController = CardLockViewController(viewModel: viewModel, navTitle: navTitle, buttonTitle: "BLOQUEAR", maskPhoneEmail: true)
        viewModel.delegate = cardLockViewController
        navigationController?.pushViewController(cardLockViewController, animated: true)
    }
    
    func navigateToConfigureCard() {
        let repository = CardDataRepository()
        let cardUseCase = CardUseCase(cardRepository: repository)
        let viewModel = ConfigureCardViewModel(router: self, successfulRouter: self, cardUseCase: cardUseCase)
        let configureCardDelegateDataSource = ConfigureCardDelegateDataSource(viewModel: viewModel)
        let viewController = ConfigureCardViewController(viewModel: viewModel, configureCardDelegateDataSource: configureCardDelegateDataSource)
        viewModel.delegate = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension AppRouter: PromotionsRouterDelegate {}
