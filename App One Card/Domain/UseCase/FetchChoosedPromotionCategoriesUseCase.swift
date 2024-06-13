//
//  FetchChoosedPromotionCategoriesUseCase.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 13/06/24.
//

import Foundation

protocol FetchChoosedPromotionCategoriesUseCaseProtocol {
    func execute() -> [CategoryFilterRequest]?
}

class FetchChoosedPromotionCategoriesUseCase: FetchChoosedPromotionCategoriesUseCaseProtocol {
    
    private let localRepository: PromotionLocalRepository
    
    init(localRepository: PromotionLocalRepository) {
        self.localRepository = localRepository
    }
  
    func execute() -> [CategoryFilterRequest]? {
        localRepository.getChoosedCategories()
    }
    
}
