//
//  PersonalDataViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import Foundation

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
    private let userUseCase: UserUseCase
    
    private let documentType: String
    private let documentNumber: String
    private let companyRUC: String
    
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
        
        userUseCase.validatePersonalData(request: request) { result in
                switch result {
                case .success(_):
                    self.delegate?.hideLoader {
                        self.verificationRouter.navigateToVerification(email: email, number: cellphone, navTitle: "REGISTRO DE USUARIO DIGITAL", stepDescription: "Paso 3 de 4") { [weak self] otpId in
                            self?.router.navigateToLoginInformation(otpId: otpId, documentType: self?.documentType ?? "", documentNumber: self?.documentNumber ?? "", companyRUC: self?.companyRUC ?? "")
                        }
                    }
                case .failure(let error):
                    self.delegate?.hideLoader {
                        self.delegate?.showError(title: error.title, description: error.description) {
                            if error.timeExpired {
                                self.router.timeExpiredRegister()
                            }
                        }
                    }
            }
        }
    }
}
