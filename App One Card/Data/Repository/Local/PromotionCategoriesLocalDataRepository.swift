//
//  PromotionCategoriesLocalDataRepository.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation
import Combine

class PromotionCategoriesLocalDataRepository: PromotionCategoriesLocalRepository {
    
    private let session: PromotionCategoriesSessionManagerProtocol
    
    init(session: PromotionCategoriesSessionManagerProtocol = PromotionCategoriesSessionManager.shared) {
        self.session = session
    }

    func saveCategories(categories: [PromotionCategory]?) {
        session.saveCategories(categories: categories)
    }
    
    func getCategories() -> [PromotionCategory]? {
        return session.getCategories()
    }
    
    func resetCategories(beforeCategories: [PromotionCategory]) -> [PromotionCategory] {
        return session.resetCategories(beforeCategories: beforeCategories)
    }
    
    func saveChoosedCategories(categories: [PromotionCategory]) {
        return session.saveChoosedCategories(categories: categories)
    }
    
    func getChoosedCategories() -> [CategoryFilterRequest]? {
        return session.getChoosedCategories()
    }
}
