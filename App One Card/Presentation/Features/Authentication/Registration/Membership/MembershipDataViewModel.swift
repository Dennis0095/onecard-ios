//
//  MembershipDataViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import Foundation
import Combine

protocol MembershipDataViewModelProtocol {
    var documentTypeList: [SelectModel] { get set }
    var documentType: SelectModel? { get set }
    var documentNumber: String? { get set }
    var companyRUC: String? { get set }
    
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping VoidActionHandler)
    func validateUser()
}

protocol MembershipDataViewModelDelegate: LoaderDisplaying {
    
}

class MembershipDataViewModel: MembershipDataViewModelProtocol {
    private let router: AuthenticationRouterDelegate
    private let userUseCase: UserUseCase
    
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
    
    init(router: AuthenticationRouterDelegate, userUseCase: UserUseCase) {
        self.router = router
        self.userUseCase = userUseCase
    }
    
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping VoidActionHandler) {
        router.showDocumentList(selected: selected, list: list, action: action, presented: presented)
    }
    
    func validateUser() {
        guard let documentTypeId = documentType?.id, let documentNumber = self.documentNumber, let companyRUC = self.companyRUC else {
            return
        }
        
        delegate?.showLoader()
        
        let request = ValidateAffiliationRequest(documentType: documentTypeId, documentNumber: documentNumber, companyRUC: companyRUC)
        userUseCase.validateAffiliation(request: request) { result in
            switch result {
            case .success(_):
                self.delegate?.hideLoader {
                    self.router.navigateToPersonalData(beforeRequest: request)
                }
            case .failure(let error):
                self.delegate?.hideLoader {
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            }
        }
    }
}
