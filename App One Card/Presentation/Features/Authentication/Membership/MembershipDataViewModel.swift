//
//  MembershipDataViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import Foundation
import Combine

protocol MembershipDataViewModelProtocol {
    var isRegister: Bool { get set }
    var documentTypeList: [SelectModel] { get set }
    var documentType: SelectModel? { get set }
    var documentNumber: String? { get set }
    var companyRUC: String? { get set }
    
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping VoidActionHandler)
    func validateUserToRegister()
    func validateUserToRecoverPassword()
}

protocol MembershipDataViewModelDelegate: LoaderDisplaying {
    
}

class MembershipDataViewModel: MembershipDataViewModelProtocol {
    private let router: AuthenticationRouterDelegate
    private let verificationRouter: VerificationRouterDelegate
    private let userUseCase: UserUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    var delegate: MembershipDataViewModelDelegate?
    var documentTypeList: [SelectModel] = [
        SelectModel(id: "1", name: "DNI"),
        SelectModel(id: "2", name: "CARNET EXTRANJERÍA"),
        SelectModel(id: "3", name: "PASAPORTE"),
        SelectModel(id: "5", name: "RUC"),
        SelectModel(id: "7", name: "PTP")
    ]
    var documentType: SelectModel?
    var documentNumber: String?
    var companyRUC: String?
    var isRegister: Bool
    
    init(router: AuthenticationRouterDelegate, verificationRouter: VerificationRouterDelegate, userUseCase: UserUseCaseProtocol, isRegister: Bool) {
        self.router = router
        self.verificationRouter = verificationRouter
        self.userUseCase = userUseCase
        self.isRegister = isRegister
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
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
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
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            } receiveValue: { response in
                let title = response.title ?? ""
                let description = response.message ?? ""
                
                self.delegate?.hideLoader()
                if response.exists == "1" {
                    self.verificationRouter.navigateToVerification(email: "", number: "", documentType: documentTypeId, documentNumber: documentNumber, companyRUC: companyRUC, navTitle: "Recuperación de clave", stepDescription: "Paso 2 de 3", operationType: "RU", maskPhoneEmail: true) { [weak self] otpId in
                        self?.router.navigateToCreatePassword(otpId: otpId, documentType: documentTypeId, documentNumber: documentNumber, companyRUC: companyRUC)
                    }
                } else {
                    self.delegate?.showError(title: title, description: description, onAccept: nil)
                }
            }
        
        cancellable.store(in: &cancellables)
    }
}
