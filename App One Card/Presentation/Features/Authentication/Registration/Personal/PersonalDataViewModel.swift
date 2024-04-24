//
//  PersonalDataViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import Foundation
import Combine

protocol PersonalDataViewModelProtocol {
    var name: String? { get set }
    var lastName: String? { get set }
    var birthday: String? { get set }
    var cellphone: String? { get set }
    var email: String? { get set }
    
    func showDateList(selected: Date?, action: @escaping SelectDateActionHandler, presented: @escaping VoidActionHandler)
    func validateFields()
}

protocol PersonalDataViewModelDelegate: LoaderDisplaying {}

class PersonalDataViewModel: PersonalDataViewModelProtocol {
    var name: String?
    var lastName: String?
    var birthday: String?
    var cellphone: String?
    var email: String?
    var delegate: PersonalDataViewModelDelegate?
    
    private let router: AuthenticationRouterDelegate
    private let verificationRouter: VerificationRouterDelegate
    private let userUseCase: UserUseCaseProtocol
    
    private let documentType: String
    private let documentNumber: String
    private let companyRUC: String
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: AuthenticationRouterDelegate, verificationRouter: VerificationRouterDelegate, userUseCase: UserUseCase, documentType: String, documentNumber: String, companyRUC: String) {
        self.router = router
        self.verificationRouter = verificationRouter
        self.documentType = documentType
        self.documentNumber = documentNumber
        self.companyRUC = companyRUC
        self.userUseCase = userUseCase
    }
    
    func showDateList(selected: Date?, action: @escaping SelectDateActionHandler, presented: @escaping VoidActionHandler) {
        router.showDateList(selected: selected, action: action, presented: presented)
    }
    
    func validateFields() {
        guard let name = name, let lastName = self.lastName, let birthday = self.birthday, let cellphone = self.cellphone, let email = self.email else {
            return
        }
        
        delegate?.showLoader()

        let request = ValidatePersonalDataRequest(documentType: documentType, documentNumber: documentNumber, companyRUC: companyRUC, name: name, lastName: lastName, birthday: birthday, cellphone: cellphone, email: email)
        
        let cancellable = userUseCase.validatePersonalData(request: request)
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
                if response.rc == "0" {
                    if response.validExpiration == "1" {
                        if response.exists == "1" {
                            self.delegate?.showError(title: title, description: description, onAccept: nil)
                        } else {
                            self.verificationRouter.navigateToVerification(email: email, number: cellphone, documentType: self.documentType, documentNumber: self.documentNumber, companyRUC: self.companyRUC, navTitle: "Registro de usuario digital", stepDescription: "Paso 3 de 4", operationType: "RU", maskPhoneEmail: false) { [weak self] otpId in
                                self?.router.navigateToLoginInformation(otpId: otpId, documentType: self?.documentType ?? "", documentNumber: self?.documentNumber ?? "", companyRUC: self?.companyRUC ?? "")
                            }
                        }
                    } else {
                        self.delegate?.showError(title: title, description: description) {
                            self.router.timeExpiredRegister()
                        }
                    }
                } else {
                    let error = APIError.defaultError.error()
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            }
        
        cancellable.store(in: &cancellables)
    }
}
