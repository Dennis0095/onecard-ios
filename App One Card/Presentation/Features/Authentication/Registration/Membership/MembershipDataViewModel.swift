//
//  MembershipDataViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import Foundation

protocol MembershipDataViewModelProtocol {
    var docType: SelectModel? { get set }
    var docNumber: String { get set }
    var docRuc: String { get set }
    
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping VoidActionHandler)
    func formValidation(isValid: Bool)
}

class MembershipDataViewModel: MembershipDataViewModelProtocol {
    var router: AuthenticationRouterDelegate
    var docType: SelectModel?
    var docNumber: String = ""
    var docRuc: String = ""
    
    init(router: AuthenticationRouterDelegate) {
        self.router = router
    }
    
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping VoidActionHandler) {
        router.showDocumentList(selected: selected, list: list, action: action, presented: presented)
    }
    
    func formValidation(isValid: Bool) {
        if isValid {
            router.navigateToPersonalData()
        }
    }
}
