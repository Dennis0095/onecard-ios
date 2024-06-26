//
//  EditUserViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/06/23.
//

import Combine

protocol EditUserViewModelProtocol {
    var beforeUsername: String { get set }
    var otpId: String { get set }
    var newUsername: String? { get set }
    
    func updateUsername()
    func successfulEdit()
}

protocol EditUserViewModelDelegate: LoaderDisplaying {
    func succesUpdate(username: String)
}

class EditUserViewModel: EditUserViewModelProtocol {
    var beforeUsername: String
    var otpId: String
    var newUsername: String?
    var profileRouter: ProfileRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    var verificationRouter: VerificationRouterDelegate
    var delegate: EditUserViewModelDelegate?
    
    private let userUseCase: UserUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(profileRouter: ProfileRouterDelegate, successfulRouter: SuccessfulRouterDelegate, verificationRouter: VerificationRouterDelegate, userUseCase: UserUseCaseProtocol, beforeUsername: String, otpId: String) {
        self.profileRouter = profileRouter
        self.successfulRouter = successfulRouter
        self.verificationRouter = verificationRouter
        self.beforeUsername = beforeUsername
        self.otpId = otpId
        self.userUseCase = userUseCase
    }
    
    func updateUsername() {
        
        guard let newUsername = self.newUsername else {
            return
        }
        
        delegate?.showLoader()
        
        let authTrackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        
        let request = UpdateUsernameRequest(otpId: otpId, newUsername: newUsername, beforeUsername: beforeUsername, authTrackingCode: authTrackingCode)
        
        let cancellable = userUseCase.updateUsername(request: request)
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
                if response.success == "1" {
                    self.delegate?.succesUpdate(username: newUsername)
                } else {
                    if response.existsUser != nil {
                        self.delegate?.showError(title: Constants.user_is_in_use, description: Constants.please_choose_another_username, onAccept: nil)
                    } else {
                        self.delegate?.showError(title: title, description: description, onAccept: nil)
                    }
                }
            }
        
        cancellable.store(in: &cancellables)
        
    }
    
    func successfulEdit() {
        self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "Has modificado tu usuario con éxito.", button: "Regresar", image: #imageLiteral(resourceName: "congratulations.svg"), accept: {
            self.profileRouter.logout(isManual: false)
        })
    }
}
