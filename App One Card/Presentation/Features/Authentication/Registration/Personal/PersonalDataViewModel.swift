//
//  PersonalDataViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import Foundation

protocol PersonalDataViewModelProtocol {
    func nextStep()
    func showDateList(selected: Date?, action: @escaping SelectDateActionHandler, presented: @escaping DismissActionHandler)
}

class PersonalDataViewModel: PersonalDataViewModelProtocol {
    var router: AuthenticationRouterDelegate?
    
    func nextStep() {
        router?.navigateToVerify()
    }
    
    func showDateList(selected: Date?, action: @escaping SelectDateActionHandler, presented: @escaping DismissActionHandler) {
        router?.showDateList(selected: selected, action: action, presented: presented)
    }
}
