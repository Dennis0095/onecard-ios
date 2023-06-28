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
    var birtdDay: String? { get set }
    var cellphone: String? { get set }
    var email: String? { get set }
    
    func nextStep()
    func showDateList(selected: Date?, action: @escaping SelectDateActionHandler, presented: @escaping VoidActionHandler)
    func validateFields()
}

class PersonalDataViewModel: PersonalDataViewModelProtocol {
    var name: String?
    var lastName: String?
    var birtdDay: String?
    var cellphone: String?
    var email: String?
    
    var router: AuthenticationRouterDelegate
    var verificationRouter: VerificationRouterDelegate
    var beforeRequest: ValidateAffiliationRequest
    
    init(router: AuthenticationRouterDelegate, verificationRouter: VerificationRouterDelegate, beforeRequest: ValidateAffiliationRequest) {
        self.router = router
        self.verificationRouter = verificationRouter
        self.beforeRequest = beforeRequest
    }
    
    func nextStep() {
        verificationRouter.navigateToVerification(navTitle: "REGISTRO DE USUARIO DIGITAL", stepDescription: "Paso 3 de 4", success: { [weak self] in
            self?.router.navigateToLoginInformation()
        })
    }
    
    func showDateList(selected: Date?, action: @escaping SelectDateActionHandler, presented: @escaping VoidActionHandler) {
        router.showDateList(selected: selected, action: action, presented: presented)
    }
    
    func validateFields() {
        guard let name = name, let lastName = self.lastName, let birtdDay = self.birtdDay, let cellphone = self.cellphone, let email = self.email else {
            return
        }
        
        
    }
}
