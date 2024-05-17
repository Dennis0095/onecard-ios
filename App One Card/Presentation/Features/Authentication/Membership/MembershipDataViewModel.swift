//
//  MembershipDataViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import Foundation
import Combine

protocol MembershipDataViewModelProtocol {
    var validateType: ValidateType { get set }
    var documentTypeList: [SelectModel] { get set }
    var documentType: SelectModel? { get set }
    var documentNumber: String? { get set }
    var companyRUC: String? { get set }
    
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping VoidActionHandler)
    func validateUserToRegister()
    func validateUserToRecoverPassword()
    func validateUserToRecoverUser()
}

protocol MembershipDataViewModelDelegate: LoaderDisplaying {}

class MembershipDataViewModel: MembershipDataViewModelProtocol {
    private let router: AuthenticationRouterDelegate
    private let verificationRouter: VerificationRouterDelegate
    private let userUseCase: UserUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    var delegate: MembershipDataViewModelDelegate?
    var documentTypeList: [SelectModel] = [
        SelectModel(id: Constants.dni_id, name: Constants.dni, placeholderName: Constants.dni_placeholder),
        SelectModel(id: Constants.immigration_card_id, name: Constants.immigration_card, placeholderName: Constants.immigration_card_placeholder),
        SelectModel(id: Constants.passport_id, name: Constants.passport, placeholderName: Constants.passport_placeholder),
        SelectModel(id: Constants.ruc_id, name: Constants.ruc, placeholderName: Constants.ruc_placeholder),
        SelectModel(id: Constants.ptp_id, name: Constants.ptp, placeholderName: Constants.ptp_placeholder)
    ]
    var documentType: SelectModel?
    var documentNumber: String?
    var companyRUC: String?
    var validateType: ValidateType
    
    init(router: AuthenticationRouterDelegate, verificationRouter: VerificationRouterDelegate, userUseCase: UserUseCaseProtocol, validateType: ValidateType) {
        self.router = router
        self.verificationRouter = verificationRouter
        self.userUseCase = userUseCase
        self.validateType = validateType
    }
    
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping VoidActionHandler) {
        router.showDocumentList(selected: selected, list: list, action: action, presented: presented)
    }
    
    func validateUserToRegister() {
        guard let documentTypeId = documentType?.id, let documentNumber = self.documentNumber, let companyRUC = self.companyRUC else {
            return
        }
        
        delegate?.showLoader()
        
        let request = ValidateAffiliationRequest(documentType: documentTypeId, documentNumber: documentNumber, companyRUC: companyRUC)
        let cancellable = userUseCase.validateAffiliation(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.delegate?.showError(title: error.title, description: error.description) {
                        switch apiError {
                        case .expiredSession:
                            self.router.logout(isManual: false)
                        default: break
                        }
                    }
                }
            } receiveValue: { response in
                let title = response.title ?? ""
                let description = response.message ?? ""
                
                self.delegate?.hideLoader()
                if response.affiliate == "1" {
                    if response.exists == "1" {
                        self.delegate?.showError(title: title, description: description, onAccept: nil)
                    } else {
                        self.router.navigateToPersonalData(beforeRequest: request)
                    }
                } else {
                    self.delegate?.showError(title: title, description: description, onAccept: nil)
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func validateUserToRecoverPassword() {
        guard let documentTypeId = documentType?.id, let documentNumber = self.documentNumber, let companyRUC = self.companyRUC else {
            return
        }
        
        delegate?.showLoader()
        
        let request = ExistsUserRequest(documentType: documentTypeId, documentNumber: documentNumber, companyRUC: companyRUC)
        let cancellable = userUseCase.existsUser(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.delegate?.showError(title: error.title, description: error.description) {
                        switch apiError {
                        case .expiredSession:
                            self.router.logout(isManual: false)
                        default: break
                        }
                    }
                }
            } receiveValue: { response in
                let title = response.title ?? ""
                let description = response.message ?? ""
                
                self.delegate?.hideLoader()
                if response.exists == "1" {
                    self.verificationRouter.navigateToVerification(email: "", number: "", documentType: documentTypeId, documentNumber: documentNumber, companyRUC: companyRUC, navTitle: "Recuperación de clave", stepDescription: "Paso 2 de 3", operationType: "RC", maskPhoneEmail: true) { [weak self] otpId in
                        self?.router.navigateToCreatePassword(otpId: otpId, documentType: documentTypeId, documentNumber: documentNumber, companyRUC: companyRUC)
                    }
                } else {
                    self.delegate?.showError(title: title, description: description, onAccept: nil)
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func validateUserToRecoverUser() {
        guard let documentTypeId = documentType?.id, let documentNumber = self.documentNumber, let companyRUC = self.companyRUC else {
            return
        }
        
        delegate?.showLoader()
        
        let request = ExistsUserRequest(documentType: documentTypeId, documentNumber: documentNumber, companyRUC: companyRUC)
        let cancellable = userUseCase.existsUser(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.delegate?.showError(title: error.title, description: error.description) {
                        switch apiError {
                        case .expiredSession:
                            self.router.logout(isManual: false)
                        default: break
                        }
                    }
                }
            } receiveValue: { response in
                let title = response.title ?? ""
                let description = response.message ?? ""
                
                self.delegate?.hideLoader()
                if response.exists == "1" {
                    self.verificationRouter.navigateToVerification(email: "", number: "", documentType: documentTypeId, documentNumber: documentNumber, companyRUC: companyRUC, navTitle: "Recuperación de usuario", stepDescription: "Paso 2 de 2", operationType: Constants.user_recovery_operation_type, maskPhoneEmail: true, success: nil)
                } else {
                    self.delegate?.showError(title: title, description: description, onAccept: nil)
                }
            }
        
        cancellable.store(in: &cancellables)
    }
}
