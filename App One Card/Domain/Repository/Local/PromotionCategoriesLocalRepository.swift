//
//  PromotionCategoriesLocalRepository.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 23/05/24.
//

import Foundation
import Combine

protocol PromotionCategoriesLocalRepository {
    func saveCategories(categories: [PromotionCategory]?)
    func getCategories() -> [PromotionCategory]?
    func resetCategories() -> [PromotionCategory]
    func saveChoosedCategories(categories: [PromotionCategory])
    func getChoosedCategories() -> [CategoryFilterRequest]?
}
