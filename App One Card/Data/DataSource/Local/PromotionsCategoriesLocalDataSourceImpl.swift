//
//  PromotionsCategoriesLocalDataSourceImpl.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 24/05/24.
//

import Foundation
import Combine

protocol PromotionsCategoriesLocalDataSource {
    func saveCategories(categories: [PromotionCategory]?)
    func getCategories() -> [PromotionCategory]?
}

class PromotionsCategoriesLocalDataSourceImpl: PromotionsCategoriesLocalDataSource {
    
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
}

