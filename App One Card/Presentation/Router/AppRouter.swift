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
    func logout()
    func confirmInactivity(closeSession: VoidActionHandler?, accept: VoidActionHandler?)
}

class AppRouter: Router {
    private let window: UIWindow
    
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
        if let navigationController = window.rootViewController as? UINavigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func logout() {
        DispatchQueue.main.async {
            let userRepository = UserDataRepository()
            let userUseCase = UserUseCase(userRepository: userRepository)
            let cardRepository = CardDataRepository()
            let cardUseCase = CardUseCase(cardRepository: cardRepository)
            let viewModel = LoginViewModel(router: self, userUseCase: userUseCase, cardUseCase: cardUseCase)
            let loginViewController = LoginViewController(viewModel: viewModel)
            viewModel.delegate = loginViewController
            let navigationController = UINavigationController(rootViewController: loginViewController)
            navigationController.setNavigationBarHidden(true, animated: true)
            UserSessionManager.shared.clearSession()
            (UIApplication.shared.delegate as! AppDelegate).invalidateTimer()
            self.window.switchRootViewController(to: navigationController)
        }
    }
    
    func confirmInactivity(closeSession: VoidActionHandler?, accept: VoidActionHandler?) {
        DispatchQueue.main.async {
            let view = InactivityModalViewController()
            view.closeSession = closeSession
            view.accept = accept
            view.modalPresentationStyle = .overFullScreen
            view.modalTransitionStyle = .crossDissolve
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.present(view, animated: true, completion: nil)
            }
        }
    }
}

extension AppRouter: AuthenticationRouterDelegate {
    func navigateToCreatePassword(otpId: String, documentType: String, documentNumber: String, companyRUC: String) {
        DispatchQueue.main.async {
            let repository = UserDataRepository()
            let useCase = UserUseCase(userRepository: repository)
            let viewModel = RecoverPasswordViewModel(router: self, successfulRouter: self, userUseCase: useCase, otpId: otpId, documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC)
            let recoverPasswordViewController = RecoverPasswordViewController(viewModel: viewModel)//LoginInformationViewController(viewModel: viewModel)
            viewModel.delegate = recoverPasswordViewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(recoverPasswordViewController, animated: true)
            }
        }
    }
    
    func navigateToForgotPassword() {
        DispatchQueue.main.async {
            let repository = UserDataRepository()
            let useCase = UserUseCase(userRepository: repository)
            let viewModel = MembershipDataViewModel(router: self, verificationRouter: self, userUseCase: useCase, validateType: .RECOVER_PASSWORD)
            let membershipDataViewController = MembershipDataViewController(viewModel: viewModel, navTitle: "Recuperación de clave", step: "Paso 1 de 3")
            viewModel.delegate = membershipDataViewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(membershipDataViewController, animated: true)
            }
        }
    }
    
    func navigateToForgotUser() {
        DispatchQueue.main.async {
            let repository = UserDataRepository()
            let useCase = UserUseCase(userRepository: repository)
            let viewModel = MembershipDataViewModel(router: self, verificationRouter: self, userUseCase: useCase, validateType: .RECOVER_USER)
            let membershipDataViewController = MembershipDataViewController(viewModel: viewModel, navTitle: "Recuperación de usuario", step: "Paso 1 de 2")
            viewModel.delegate = membershipDataViewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(membershipDataViewController, animated: true)
            }
        }
    }
    
    func timeExpiredRegister() {
        if let navigationController = window.rootViewController as? UINavigationController {
            for viewController in navigationController.viewControllers {
                if let membershipDataViewController = viewController as? MembershipDataViewController {
                    navigationController.popToViewController(membershipDataViewController, animated: true)
                    break
                }
            }
        }
    }
    
    func navigateToConfirmPin(operationId: String, newPin: String, success: @escaping PinActionHandler) {
        DispatchQueue.main.async {
            let cardRepository = CardDataRepository()
            let keyRepository = KeyDataRepository()
            let cardUseCase = CardUseCase(cardRepository: cardRepository)
            let keyUseCase = KeyUseCase(keyRepository: keyRepository)
            let viewModel = PinViewModel(router: self, cardUseCase: cardUseCase, keyUseCase: keyUseCase, pinStep: .cardActivation)
            viewModel.success = success
            viewModel.newPin = newPin
            viewModel.operationId = operationId
            let viewController = PinViewController(viewModel: viewModel, navTitle: "Activación de tarjeta", step: "Paso 3 de 3", titleDescription: "Confirme su nuevo PIN", buttonTitle: Constants.next_btn, placeholder: "Nuevo PIN", isConfirmPin: true)
            viewModel.delegate = viewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: true)
            }
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
            let viewController = PinViewController(viewModel: viewModel, navTitle: "Activación de tarjeta", step: "Paso 2 de 3", titleDescription: "Ingresa tu nuevo PIN", buttonTitle: Constants.next_btn, placeholder: "Nuevo PIN")
            viewModel.delegate = viewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: true)
            }
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
            let viewController = PinViewController(viewModel: viewModel, navTitle: "Activación de tarjeta", step: "Paso 1 de 3", titleDescription: "Ingresa el PIN de la tarjeta", description: "Puede encontrarlo dentro del sobre de la tarjeta.", buttonTitle: Constants.next_btn, placeholder: "PIN de la tarjeta")
            viewModel.delegate = viewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func navigateToActivateUser() {
        DispatchQueue.main.async {
            let viewModel = WelcomeActivateViewModel(router: self, successfulRouter: self)
            let welcomeActivateViewController = WelcomeActivateViewController(viewModel: viewModel)
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(welcomeActivateViewController, animated: true)
            }
        }
    }
    
    func navigateToLoginInformation(otpId: String, documentType: String, documentNumber: String, companyRUC: String) {
        DispatchQueue.main.async {
            let repository = UserDataRepository()
            let useCase = UserUseCase(userRepository: repository)
            let viewModel = LoginInformationViewModel(router: self, successfulRouter: self, userUseCase: useCase, otpId: otpId, documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC)
            let loginInformationViewController = LoginInformationViewController(viewModel: viewModel)
            viewModel.delegate = loginInformationViewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(loginInformationViewController, animated: true)
            }
        }
    }
    
    func navigateToPersonalData(beforeRequest: ValidateAffiliationRequest) {
        DispatchQueue.main.async {
            let repository = UserDataRepository()
            let useCase = UserUseCase(userRepository: repository)
            let viewModel = PersonalDataViewModel(router: self, verificationRouter: self, userUseCase: useCase, documentType: beforeRequest.documentType, documentNumber: beforeRequest.documentNumber, companyRUC: beforeRequest.companyRUC)
            let personalDataViewController = PersonalDataViewController(viewModel: viewModel)
            viewModel.delegate = personalDataViewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(personalDataViewController, animated: true)
            }
        }
    }
    
    func navigateToRegister() {
        DispatchQueue.main.async {
            let repository = UserDataRepository()
            let useCase = UserUseCase(userRepository: repository)
            let viewModel = MembershipDataViewModel(router: self, verificationRouter: self, userUseCase: useCase, validateType: .REGISTER)
            let membershipDataViewController = MembershipDataViewController(viewModel: viewModel, navTitle: "Registro de usuario digital", step: "Paso 1 de 4")
            viewModel.delegate = membershipDataViewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(membershipDataViewController, animated: true)
            }
        }
    }
    
    func navigateToHome() {
        DispatchQueue.main.async {
            let menu = MenuTabBarController(homeRouter: self, authRouter: self, configurationRouter: self, successfulRouter: self, promotionsRouter: self)
            let navigationController = UINavigationController(rootViewController: menu)
            navigationController.setNavigationBarHidden(true, animated: true)
            self.window.switchRootViewController(to: navigationController)
        }
    }
    
    func navigateToLogin() {
        DispatchQueue.main.async {
            let userRepository = UserDataRepository()
            let userUseCase = UserUseCase(userRepository: userRepository)
            let cardRepository = CardDataRepository()
            let cardUseCase = CardUseCase(cardRepository: cardRepository)
            let viewModel = LoginViewModel(router: self, userUseCase: userUseCase, cardUseCase: cardUseCase)
            let loginViewController = LoginViewController(viewModel: viewModel)
            viewModel.delegate = loginViewController
            let navigationController = UINavigationController(rootViewController: loginViewController)
            navigationController.setNavigationBarHidden(true, animated: true)
            self.window.switchRootViewController(to: navigationController)
        }
    }
    
    func showDateList(selected: Date?, action: @escaping SelectDateActionHandler, presented: @escaping VoidActionHandler) {
        DispatchQueue.main.async {
            let contentView = SelectDateViewController()
            contentView.textTitle = Constants.placeholder_birthday
            contentView.selectedItem = selected
            contentView.actionHandler = action
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.setValue(contentView, forKey: "contentViewController")
            alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
            alertController.view.tintColor = UIColor.white
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.present(alertController, animated: true, completion: presented)
            }
        }
    }
    
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping VoidActionHandler) {
        DispatchQueue.main.async {
            let contentView = SelectCustomViewController()
            contentView.textTitle = Constants.placeholder_document_type
            contentView.items = list
            contentView.selectedItem = selected
            contentView.actionHandler = action
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.setValue(contentView, forKey: "contentViewController")
            alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
            alertController.view.tintColor = UIColor.white
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.present(alertController, animated: true, completion: presented)
            }
        }
    }
}

extension AppRouter: VerificationRouterDelegate {
    func navigateToVerification(email: String, number: String, documentType: String, documentNumber: String, companyRUC: String, navTitle: String, stepDescription: String, operationType: String, maskPhoneEmail: Bool, success: @escaping VerificationActionHandler) {
        DispatchQueue.main.async {
            let repository = OTPDataRepository()
            let useCase = OTPUseCase(otpRepository: repository)
            let viewModel = VerificationViewModel(router: self, otpUseCase: useCase, documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC, email: email, number: number, operationType: operationType, maskPhoneEmail: maskPhoneEmail)
            viewModel.success = success
            let verificationViewController = VerificationViewController(viewModel: viewModel, navTitle: navTitle, step: stepDescription, titleDescription: "Ingresa tu código de validación", buttonTitle: Constants.next_btn)
            viewModel.delegate = verificationViewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(verificationViewController, animated: true)
            }
        }
    }
}

extension AppRouter: SuccessfulRouterDelegate {
    func navigateToSuccessfulScreen(title: String, description: String, button: String, image: UIImage, accept: VoidActionHandler?) {
        DispatchQueue.main.async {
            let successfulViewController = SuccessfulViewController()
            successfulViewController.titleSuccessful = title
            successfulViewController.descriptionSuccessful = description
            successfulViewController.buttonSuccessful = button
            successfulViewController.imageSuccessful = image
            successfulViewController.accept = accept
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(successfulViewController, animated: true)
            }
        }
    }
}

extension AppRouter: ConfigurationRouterDelegate {
    func confirmLogout(accept: VoidActionHandler?) {
        DispatchQueue.main.async {
            let view = LogoutModalViewController()
            view.accept = accept
            view.modalPresentationStyle = .overFullScreen
            view.modalTransitionStyle = .crossDissolve
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.present(view, animated: true, completion: nil)
            }
        }
    }
    
    func navigateToProfile() {
        DispatchQueue.main.async {
            let userRepository = UserDataRepository()
            let userUseCase = UserUseCase(userRepository: userRepository)
            let viewModel = ProfileViewModel(router: self, verificationRouter: self, userUseCase: userUseCase)
            let profileViewController = ProfileViewController(viewModel: viewModel)
            viewModel.delegate = profileViewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(profileViewController, animated: true)
            }
        }
    }
    
    func navigateToQuestions() {
        DispatchQueue.main.async {
            let repository = QuestionDataRepository()
            let useCase = QuestionUseCase(questionRepository: repository)
            let viewModel = FrequentQuestionsViewModel(questionUseCase: useCase)
            let frequentQuestionsDelegateDataSource = FrequentQuestionsDelegateDataSource(viewModel: viewModel)
            let viewController = FrequentQuestionsViewController(viewModel: viewModel, frequentQuestionsDelegateDataSource: frequentQuestionsDelegateDataSource)
            viewModel.delegate = viewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension AppRouter: ProfileRouterDelegate {
    func toEditPassword() {
        DispatchQueue.main.async {
            let userDataRepository = UserDataRepository()
            let userUseCase = UserUseCase(userRepository: userDataRepository)
            let viewModel = ChangePasswordViewModel(profileRouter: self, successfulRouter: self, userUseCase: userUseCase)
            let changePasswordViewController = ChangePasswordViewController(viewModel: viewModel)
            viewModel.delegate = changePasswordViewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(changePasswordViewController, animated: true)
            }
        }
    }
    
    func toEditUser(beforeUsername: String, otpId: String, success: @escaping EditUserSuccessActionHandler) {
        DispatchQueue.main.async {
            let userDataRepository = UserDataRepository()
            let userUseCase = UserUseCase(userRepository: userDataRepository)
            let viewModel = EditUserViewModel(profileRouter: self, successfulRouter: self, verificationRouter: self, userUseCase: userUseCase, beforeUsername: beforeUsername, otpId: otpId)
            let editUserViewController = EditUserViewController(viewModel: viewModel)
            viewModel.delegate = editUserViewController
            editUserViewController.success = success
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(editUserViewController, animated: true)
            }
        }
    }
    
    func toEditMail(beforeEmail: String, otpId: String, success: @escaping EditMailSuccessActionHandler) {
        DispatchQueue.main.async {
            let userDataRepository = UserDataRepository()
            let userUseCase = UserUseCase(userRepository: userDataRepository)
            let viewModel = EditMailViewModel(profileRouter: self, successfulRouter: self, verificationRouter: self, userUseCase: userUseCase, beforeEmail: beforeEmail, otpId: otpId)
            let editMailViewController = EditMailViewController(viewModel: viewModel)
            viewModel.delegate = editMailViewController
            editMailViewController.success = success
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(editMailViewController, animated: true)
            }
        }
    }
    
    func successfulEditProfile() {
        if let navigationController = self.window.rootViewController as? UINavigationController {
            for viewController in navigationController.viewControllers {
                if let profileViewController = viewController as? ProfileViewController {
                    navigationController.popToViewController(profileViewController, animated: true)
                    break
                }
            }
        }
    }
}

extension AppRouter: HomeRouterDelegate {
    func navigatetoFrequentQuestions() {
        DispatchQueue.main.async {
            let repository = QuestionDataRepository()
            let useCase = QuestionUseCase(questionRepository: repository)
            let viewModel = FrequentQuestionsViewModel(questionUseCase: useCase)
            let frequentQuestionsDelegateDataSource = FrequentQuestionsDelegateDataSource(viewModel: viewModel)
            let viewController = FrequentQuestionsViewController(viewModel: viewModel, frequentQuestionsDelegateDataSource: frequentQuestionsDelegateDataSource)
            viewModel.delegate = viewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func navigateToMovements() {
        DispatchQueue.main.async {
            let movementRepository = MovementDataRepository()
            let useCase = MovementUseCase(movementRepository: movementRepository)
            let viewModel = MovementsViewModel(router: self, movementUseCase: useCase)
            let movementsDelegateDataSource = MovementsDelegateDataSource(viewModel: viewModel)
            let movementsViewController = MovementsViewController(viewModel: viewModel, movementsDelegateDataSource: movementsDelegateDataSource)
            viewModel.delegate = movementsViewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(movementsViewController, animated: true)
            }
        }
    }
    
    func navigateToMovementDetail(movement: MovementResponse) {
        DispatchQueue.main.async {
            let view = MovementDetailViewController(movement: movement)
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(view, animated: true)
            }
        }
    }
    
    func confirmCardLock(accept: VoidActionHandler?) {
        DispatchQueue.main.async {
            let view = CardLockModalViewController()
            view.accept = accept
            view.modalPresentationStyle = .overFullScreen
            view.modalTransitionStyle = .crossDissolve
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.present(view, animated: true, completion: nil)
            }
        }
    }
    
    func navigateToInputPinConfirmation(newPin: String, operationId: String, success: @escaping PinActionHandler) {
        DispatchQueue.main.async {
            let cardRepository = CardDataRepository()
            let keyRepository = KeyDataRepository()
            let cardUseCase = CardUseCase(cardRepository: cardRepository)
            let keyUseCase = KeyUseCase(keyRepository: keyRepository)
            let viewModel = PinViewModel(router: self, cardUseCase: cardUseCase, keyUseCase: keyUseCase, pinStep: .reassign)
            viewModel.success = success
            viewModel.newPin = newPin
            viewModel.operationId = operationId
            let viewController = PinViewController(viewModel: viewModel, navTitle: "Cambio de PIN", step: "Paso 3 de 3", titleDescription: "Confirme su nuevo PIN", buttonTitle: Constants.next_btn, placeholder: "Nuevo PIN", isConfirmPin: true)
            viewModel.delegate = viewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: true)
            }
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
            let viewController = PinViewController(viewModel: viewModel, navTitle: "Cambio de PIN", step: "Paso 2 de 3", titleDescription: "Ingresa tu nuevo PIN", buttonTitle: Constants.next_btn, placeholder: "Nuevo PIN")
            viewModel.delegate = viewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: true)
            }
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
            let viewController = PinViewController(viewModel: viewModel, navTitle: "Cambio de PIN", step: "Paso 1 de 3", titleDescription: "Ingresa tu PIN actual", buttonTitle: Constants.next_btn, placeholder: "PIN actual")
            viewModel.delegate = viewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func successfulConfigureCard() {
        if let navigationController = self.window.rootViewController as? UINavigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func successfulCardBlock() {
        if let navigationController = self.window.rootViewController as? UINavigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func navigateToCardBlock(navTitle: String, success: @escaping VerificationActionHandler) {
        DispatchQueue.main.async {
            let repository = OTPDataRepository()
            let useCase = OTPUseCase(otpRepository: repository)
            let cardRepository = CardDataRepository()
            let cardUseCase = CardUseCase(cardRepository: cardRepository)
            let viewModel = CardLockViewModel(router: self, successfulRouter: self, otpUseCase: useCase, cardUseCase: cardUseCase)
            viewModel.success = success
            let cardLockViewController = CardLockViewController(viewModel: viewModel, navTitle: navTitle, buttonTitle: "Bloquear")
            viewModel.delegate = cardLockViewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(cardLockViewController, animated: true)
            }
        }
    }
    
    func navigateToConfigureCard() {
        DispatchQueue.main.async {
            let repository = CardDataRepository()
            let cardUseCase = CardUseCase(cardRepository: repository)
            let viewModel = ConfigureCardViewModel(router: self, successfulRouter: self, cardUseCase: cardUseCase)
            let configureCardDelegateDataSource = ConfigureCardDelegateDataSource(viewModel: viewModel)
            let viewController = ConfigureCardViewController(viewModel: viewModel, configureCardDelegateDataSource: configureCardDelegateDataSource)
            viewModel.delegate = viewController
            if let navigationController = self.window.rootViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension AppRouter: PromotionsRouterDelegate {}
