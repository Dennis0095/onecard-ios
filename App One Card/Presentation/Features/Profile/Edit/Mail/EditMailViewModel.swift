//
//  EditMailViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 12/06/23.
//

import Combine

protocol EditMailViewModelProtocol {
    var beforeEmail: String { get set }
    var otpId: String { get set }
    var newEmail: String? { get set }
    
    func updateEmail()
    func successfulEdit()
}

protocol EditMailViewModelDelegate: LoaderDisplaying {
    func succesUpdate()
}

class EditMailViewModel: EditMailViewModelProtocol {
    var beforeEmail: String
    var otpId: String
    var newEmail: String?
    var profileRouter: ProfileRouterDelegate
    var successfulRouter: SuccessfulRouterDelegate
    var verificationRouter: VerificationRouterDelegate
    var delegate: EditMailViewModelDelegate?
    
    private let userUseCase: UserUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(profileRouter: ProfileRouterDelegate, successfulRouter: SuccessfulRouterDelegate, verificationRouter: VerificationRouterDelegate, userUseCase: UserUseCaseProtocol, beforeEmail: String, otpId: String) {
        self.profileRouter = profileRouter
        self.successfulRouter = successfulRouter
        self.verificationRouter = verificationRouter
        self.userUseCase = userUseCase
        self.beforeEmail = beforeEmail
        self.otpId = otpId
    }
    
    func updateEmail() {
        
        guard let newEmail = self.newEmail else {
            return
        }
        
        delegate?.showLoader()
        
        let authTrackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        
        let request = UpdateEmailRequest(otpId: otpId, newEmail: newEmail, beforeEmail: beforeEmail, authTrackingCode: authTrackingCode)
        
        let cancellable = userUseCase.updateEmail(request: request)
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
                    self.delegate?.succesUpdate()
                } else {
                    self.delegate?.showError(title: title, description: description, onAccept: nil)
                }
            }
        
        cancellable.store(in: &cancellables)
        
    }
    
    func successfulEdit() {
        self.successfulRouter.navigateToSuccessfulScreen(title: Constants.congratulations, description: "Ha modificado su correo electrónico con éxito.", button: "Regresar", image: #imageLiteral(resourceName: "congratulations.svg"), accept: {
            self.profileRouter.successfulEditProfile()
        })
    }
}
