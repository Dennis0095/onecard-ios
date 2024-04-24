//
//  RecoverPasswordViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 8/08/23.
//

import Foundation
import Combine

protocol RecoverPasswordViewModelProtocol {
    var password: String? { get set }
    var passwordOk: String? { get set }
    var delegate: RecoverPasswordViewModelDelegate? { get set }
    
    func recoverPassword()
    func navigateToSuccessfulScreen()
}

protocol RecoverPasswordViewModelDelegate: LoaderDisplaying {
    func success()
}

class RecoverPasswordViewModel: RecoverPasswordViewModelProtocol {
    var password: String?
    var passwordOk: String?
    var delegate: RecoverPasswordViewModelDelegate?
    
    private let router: AuthenticationRouterDelegate
    private let successfulRouter: SuccessfulRouterDelegate
    private let userUseCase: UserUseCase
    
    private let otpId: String
    private let documentType: String
    private let documentNumber: String
    private let companyRUC: String
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: AuthenticationRouterDelegate, successfulRouter: SuccessfulRouterDelegate, userUseCase: UserUseCase, otpId: String, documentType: String, documentNumber: String, companyRUC: String) {
        self.router = router
        self.successfulRouter = successfulRouter
        self.userUseCase = userUseCase
        self.otpId = otpId
        self.documentType = documentType
        self.documentNumber = documentNumber
        self.companyRUC = companyRUC
    }
    
    deinit {
        cancelRequests()
    }
    
    func navigateToSuccessfulScreen() {
        self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: Constants.congratulations_description, button: Constants.login_btn, image: #imageLiteral(resourceName: "congratulations.svg")) {
            self.router.navigateToLogin()
        }
    }
    
    func recoverPassword() {
        guard let password = self.password, let passwordOk = self.passwordOk else {
            return
        }
        
        let request = NewPasswordRequest(otpId: otpId, documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC, newPassword: password, confirmNewPassword: passwordOk)
        
        let cancellable = userUseCase.createNewPassword(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            } receiveValue: { response in
                let title = response.title ?? ""
                let description = response.message ?? ""
                
                self.delegate?.hideLoader()
                if response.success == "1" {
                    self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "Has restablecido tu clave digital con éxito.", button: Constants.login_btn, image: #imageLiteral(resourceName: "congratulations.svg")) {
                        self.router.navigateToLogin()
                    }
                } else {
                    self.delegate?.showError(title: title, description: description, onAccept: nil)
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

