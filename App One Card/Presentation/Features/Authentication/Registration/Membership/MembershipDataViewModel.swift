//
//  MembershipDataViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import Foundation

protocol MembershipDataViewModelProtocol {
    func nextStep()
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping DismissActionHandler)
}

class MembershipDataViewModel: MembershipDataViewModelProtocol {
    var router: AuthenticationRouterDelegate?
    
    func nextStep() {
        router?.navigateToPersonalData()
    }
    
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping DismissActionHandler) {
        router?.showDocumentList(selected: selected, list: list, action: action, presented: presented)
    }
}
