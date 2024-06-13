//
//  ResetPromotionCategoriesUseCase.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 13/06/24.
//

import Foundation

protocol ResetPromotionCategoriesUseCaseProtocol {
    func execute(beforeCategories: [PromotionCategory]) -> [PromotionCategory]
}

class ResetPromotionCategoriesUseCase: ResetPromotionCategoriesUseCaseProtocol {
    
    private let localRepository: PromotionLocalRepository
    
    init(localRepository: PromotionLocalRepository) {
        self.localRepository = localRepository
    }
  
    func execute(beforeCategories: [PromotionCategory]) -> [PromotionCategory] {
        return localRepository.resetCategories(beforeCategories: beforeCategories)
    }
    
}
