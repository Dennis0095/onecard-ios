//
//  ChangePasswordViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 20/07/23.
//

import Foundation
import Combine

protocol ChangePasswordViewModelProtocol {
    var password: String? { get set }
    var newPassword: String? { get set }
    var passwordOk: String? { get set }
    var delegate: ChangePasswordViewModelDelegate? { get set }
    
    func updatePassword()
    func successfulEdit()
}

protocol ChangePasswordViewModelDelegate: LoaderDisplaying {
    func succesUpdate()
}

class ChangePasswordViewModel: ChangePasswordViewModelProtocol {
    var password: String?
    var newPassword: String?
    var passwordOk: String?
    var delegate: ChangePasswordViewModelDelegate?
    var profileRouter: ProfileRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    
    private let userUseCase: UserUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(profileRouter: ProfileRouterDelegate, successfulRouter: SuccessfulRouterDelegate, userUseCase: UserUseCaseProtocol) {
        self.profileRouter = profileRouter
        self.successfulRouter = successfulRouter
        self.userUseCase = userUseCase
    }
    
    func updatePassword() {
        guard let password = self.password, let newPassword = self.newPassword, let passwordOk = self.passwordOk else {
            return
        }
        
        guard password != newPassword else {
            delegate?.showError(title: "Clave utilizada recientemente", description: "La clave ingresada es igual a la actual, por favor ingresa una clave diferente", onAccept: nil)
            
            return
        }
        
        delegate?.showLoader()
        
        let authTrackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
                
        let request = UpdatePasswordRequest(authTrackingCode: authTrackingCode, currentPassword: password, newPassword: newPassword, confirmNewPassword: passwordOk)
        
        let cancellable = userUseCase.updatePassword(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.delegate?.showError(title: error.title, description: error.description) {
                        switch apiError {
                        case .expiredSession:
                            self.profileRouter.logout(isManual: false)
                        default: break
                        }
                    }
                }
            } receiveValue: { response in
                let title = response.title ?? ""
                let description = response.message ?? ""
                
                self.delegate?.hideLoader()
                if response.matchNewPassword == "0" && response.formNewPassword == "1" && response.matchCurrentPassword == "1" && response.validateNewPassword == "1" {
                    self.delegate?.succesUpdate()
                } else {
                    self.delegate?.showError(title: title, description: description, onAccept: nil)
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func successfulEdit() {
        self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "Has modificado tu clave digital con éxito.", button: "Regresar", image: #imageLiteral(resourceName: "congratulations.svg"), accept: {
            self.profileRouter.logout(isManual: false)
        })
    }
}
