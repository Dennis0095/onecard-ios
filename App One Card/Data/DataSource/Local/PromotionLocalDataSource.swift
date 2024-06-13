//
//  PromotionLocalDataSource.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 13/06/24.
//

import Foundation
import Combine

class PromotionLocalDataSource: PromotionLocalDataSourceProtocol {
    
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
