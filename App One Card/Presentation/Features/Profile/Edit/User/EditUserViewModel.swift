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
    func succesUpdate()
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
                case .failure(let error):
                    self.delegate?.hideLoader {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            } receiveValue: { response in
                let title = response.title ?? ""
                let description = response.message ?? ""
                
                self.delegate?.hideLoader {
                    if response.success == "1" {
                        self.delegate?.succesUpdate()
                    } else {
                        self.delegate?.showError(title: title, description: description, onAccept: nil)
                    }
                }
            }
        
        cancellable.store(in: &cancellables)
        
        
    }
    
    func successfulEdit() {
        self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "Ha modificado su usuario con éxito.", button: "REGRESAR", accept: {
            self.profileRouter.successfulEditProfile()
        })
    }
}
