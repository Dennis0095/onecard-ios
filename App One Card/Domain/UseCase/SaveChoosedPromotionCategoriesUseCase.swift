//
//  SaveChoosedPromotionCategoriesUseCase.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 13/06/24.
//

import Foundation

protocol SaveChoosedPromotionCategoriesUseCaseProtocol {
    func execute(categories: [PromotionCategory])
}

class SaveChoosedPromotionCategoriesUseCase: SaveChoosedPromotionCategoriesUseCaseProtocol {
    
    private let localRepository: PromotionLocalRepository
    
    init(localRepository: PromotionLocalRepository) {
        self.localRepository = localRepository
    }
  
    func execute(categories: [PromotionCategory]) {
        localRepository.saveChoosedCategories(categories: categories)
    }
    
}
