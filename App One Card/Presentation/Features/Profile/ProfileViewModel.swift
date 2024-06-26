//
//  ProfileViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 11/06/23.
//

import Foundation
import Combine

protocol ProfileViewModelProtocol {
    var wasShownViewProfile: Bool { get set }
    var userResponse: ConsultUserDataResponse? { get set }
    
    func getUserData()
    func toEditMail()
    func toEditUser()
    func toEditPassword()
}

protocol ProfileViewModelDelegate: LoaderDisplaying {
    func showData(user: ConsultUserDataResponse)
    func failureShowData(error: APIError)
}

class ProfileViewModel: ProfileViewModelProtocol {
    var router: ProfileRouterDelegate
    var verificationRouter: VerificationRouterDelegate
    var delegate: ProfileViewModelDelegate?
    var userResponse: ConsultUserDataResponse?
    var wasShownViewProfile: Bool = false
    
    private let userUseCase: UserUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: ProfileRouterDelegate, verificationRouter: VerificationRouterDelegate, userUseCase: UserUseCaseProtocol) {
        self.router = router
        self.verificationRouter = verificationRouter
        self.userUseCase = userUseCase
    }
    
    func getUserData() {
        delegate?.showLoader()
        
        let authTrackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        
        let request = ConsultUserDataRequest(authTrackingCode: authTrackingCode)
        
        let cancellable = userUseCase.data(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    switch apiError {
                    case .expiredSession:
                        self.delegate?.showError(title: error.title, description: error.description) {
                            self.router.logout(isManual: false)
                        }
                    default:
                        if !self.wasShownViewProfile {
                            self.delegate?.failureShowData(error: apiError)
                        } else {
                            self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                        }
                    }
                }
            } receiveValue: { response in
                self.wasShownViewProfile = true
                self.delegate?.hideLoader()
                self.userResponse = response
                self.delegate?.showData(user: response)
            }
        cancellable.store(in: &cancellables)

    }
    
    func toEditMail() {
        let email = userResponse?.email ?? ""
        let number = userResponse?.truncatedCellphone ?? ""
        let documentType = userResponse?.docType ?? ""
        let documentNumber = userResponse?.docNumber ?? ""
        let companyRUC = userResponse?.companyRUC ?? ""
        
        verificationRouter.navigateToVerification(email: email, number: number, documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC, navTitle: "Modifica tu correo electrónico", stepDescription: "Paso 1 de 2", operationType: "AE", maskPhoneEmail: true) { [weak self] otpId in
            self?.router.toEditMail(beforeEmail: email, otpId: otpId) {
                self?.userResponse?.email = $0
                if let user = self?.userResponse {
                    self?.delegate?.showData(user: user)
                }
            }
        }
    }
    
    func toEditUser() {
        let email = userResponse?.email ?? ""
        let number = userResponse?.truncatedCellphone ?? ""
        let documentType = userResponse?.docType ?? ""
        let documentNumber = userResponse?.docNumber ?? ""
        let companyRUC = userResponse?.companyRUC ?? ""
        let username = userResponse?.userName ?? ""
        
        verificationRouter.navigateToVerification(email: email, number: number, documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC, navTitle: "Cambio de usuario", stepDescription: "Paso 1 de 2", operationType: "AU", maskPhoneEmail: true) { [weak self] otpId in
            self?.router.toEditUser(beforeUsername: username, otpId: otpId) {
                self?.userResponse?.userName = $0
                if let user = self?.userResponse {
                    self?.delegate?.showData(user: user)
                }
            }
        }
    }
    
    func toEditPassword() {
        router.toEditPassword()
    }
}
